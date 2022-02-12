defmodule SarqXReporter.CLI do
  alias SarqXReporter.{Systemd, Help, StatLogger}
  require Logger

  @credential Application.get_env(:sarqx_reporter, :path_to_credential_file)
  @host Application.get_env(:sarqx_reporter, :server_host)
  @base_url @host <> "/api/rest/v1"

  @moduledoc """
  To compile application type `mix escript.build`.
  To start application type `./sarqx_reporter`
  """

  def main(args) do
    args |> parse_args |> process_args
  end

  def parse_args(["--run", path]) do
    {params, _, _} = OptionParser.parse(["--run", path], strict: [run: :string])
    params
  end

  def parse_args(args) do
    {params, _, _} = OptionParser.parse(args, switches: [help: :boolean])
    params
  end

  # TODO: return commands list when user does not pass any args
  def process_args(status: true), do: Systemd.execute("status")
  def process_args(enable: true), do: Systemd.execute("enable")
  def process_args(disable: true), do: Systemd.execute("disable")
  def process_args(start: true), do: Systemd.execute("start")
  def process_args(stop: true), do: Systemd.execute("stop")

  def process_args(run: log_dir_path) do
    pid = spawn(StatLogger, :execute, [log_dir_path])
    self_pid = self()
    send(pid, {:ok, self_pid})

    result =
      receive do
        :ok -> %{"status" => "ok"}
        {:new, cpu_stat} -> %{"status" => "new", "cpu_stat" => cpu_stat}
      end

    {:ok, report} = Jason.encode(result)

    {:ok, credentials} = File.read(@credential)
    {:ok, credentials} = Jason.decode(credentials)
    credentials = URI.encode_query(credentials)
    token_type = "Phoenix"
    token = token_type <> " " <> SarqXReporter.Token.sign(credentials)

    HTTPoison.post(@base_url <> "/reports", report, [
      {"Content-Type", "application/json"},
      {"Authorization", token}
    ])

    Process.sleep(5000)

    process_args(run: log_dir_path)
  end

  def process_args(register: true) do
    if File.exists?(@credential) == true do
      IO.puts("Reporter already registered.")
    else
      IO.puts("Please fill in the fields.")
      email = IO.gets("Email: ") |> String.trim()
      name = IO.gets("Name: ") |> String.trim()
      surname = IO.gets("Surname: ") |> String.trim()
      device_type = IO.gets("Type of device: ") |> String.trim()

      {:ok, request_body} =
        Jason.encode(%{
          "email" => email,
          "name" => name,
          "surname" => surname,
          "device_type" => device_type
        })

      {:ok, response} =
        HTTPoison.post(@base_url <> "/reporter", request_body, [
          {"Content-Type", "application/json"}
        ])

      mocked_response = %{client_id: 314, client_secret: "secreto"}

      File.write!(@credential, Jason.encode!(mocked_response))

      IO.puts("Your reporter successfully registered.")
    end
  end

  def process_args(edit: true) do
    if File.exists?(@credential) == true do
      IO.puts("Please fill in the fields.")
      email = IO.gets("Email: ") |> String.trim()
      name = IO.gets("Name: ") |> String.trim()
      surname = IO.gets("Surname: ") |> String.trim()
      device_type = IO.gets("Type of device: ") |> String.trim()

      {:ok, request_body} =
        Jason.encode(%{
          "email" => email,
          "name" => name,
          "surname" => surname,
          "device_type" => device_type
        })

      {:ok, response} =
        HTTPoison.patch(@base_url <> "/reporter", request_body, [
          {"Content-Type", "application/json"}
        ])

      IO.puts("Reporter successfully edited.")
    else
      IO.puts("Reporter does not registered.")
    end
  end

  def process_args(help: true), do: Help.execute()

  def process_args(_) do
    IO.puts("Welcome to the SarqX CLI!")
    Help.execute()
    receive_command()
  end

  defp receive_command do
    IO.gets("\n> ")
    |> String.trim()
    |> String.downcase()
    |> run_command
  end

  defp run_command(_unknown) do
    IO.puts("\nInvalid command. I don't know what to do.")
    Help.execute()

    receive_command()
  end
end
