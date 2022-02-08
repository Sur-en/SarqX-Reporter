defmodule SarqXReporter.CLI do
  alias SarqXReporter.{Systemd, Help, StatLogger}
  require Logger

  @host Application.get_env(:sarqx_reporter, :server_host)

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

  # TODO: get directory path as function argument
  def process_args(run: log_dir_path) do
    result =
      case StatLogger.execute(log_dir_path) do
        :ok -> %{"status" => "ok"}
        {:new, cpu_stat} -> %{"status" => "new", "cpu_stat" => cpu_stat}
      end

    {:ok, report} = Jason.encode(result)

    HTTPoison.post(
      "#{@host}/api/rest/v1/reports",
      report,
      [{"Content-Type", "application/json"}]
    )
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
