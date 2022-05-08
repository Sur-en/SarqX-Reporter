defmodule SarqXReporter.StatLogger do
  def execute(directory) do
    receive do
      {:ok, sender} ->
        {cpu_stat, _} =
          case System.shell("whoami") do
            {"root\n", _} ->
              System.shell("dmidecode -t processor")

            _ ->
              :error
          end

        cpu_stat = String.slice(cpu_stat, 0..-2)
        sha1 = :crypto.hash(:sha, cpu_stat) |> Base.encode16() |> String.downcase()

        file_name = "#{sha1}.srq"
        file_path = Path.join([directory, file_name])

        case File.exists?(file_path) do
          true ->
            append_log(file_path)
            send(sender, {:ok, sha1})

          false ->
            add_log(file_path, cpu_stat)
            send(sender, {:new, cpu_stat})
        end
    end
  end

  defp append_log(file_path) do
    status = "OK"
    timestamp = make_timestamp()
    header = compose_timestamp_and_status(timestamp, status) <> "\n"

    File.write(file_path, header, [:append])
  end

  defp add_log(file_path, stat) do
    status = "NEW"
    timestamp = make_timestamp()
    header = compose_timestamp_and_status(timestamp, status)
    content = "#{header}\n#{stat}"

    case touch_file(file_path) do
      :ok -> File.write(file_path, content)
      error -> error
    end
  end

  defp touch_file(path) do
    case File.touch(path) do
      :ok -> :ok
      error -> error
    end
  end

  defp make_timestamp do
    DateTime.utc_now()
    |> DateTime.truncate(:second)
    |> DateTime.to_iso8601()
    |> String.replace("T", " ")
    |> String.replace("Z", "")
  end

  defp compose_timestamp_and_status(timestamp, status) do
    "[#{timestamp}] [#{status}]"
  end
end
