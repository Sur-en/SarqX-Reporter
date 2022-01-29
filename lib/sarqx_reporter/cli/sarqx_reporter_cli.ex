defmodule SarqXReporter.CLI do
  @moduledoc """
  To compile application type `mix escript.build`.
  To start application type `./sarqx_reporter`
  """

  def main(args) do
    args |> parse_args |> process_args
  end

  def parse_args(args) do
    {params, _, _} = OptionParser.parse(args, switches: [help: :boolean])
    params
  end

  # TODO: return commands list when user does not pass any args
  def process_args(help: true), do: print_help_message()
  def process_args(register: true), do: execute_command("setup")
  def process_args(connect: true), do: execute_command("connect")
  def process_args(status: true), do: execute_service("status")
  def process_args(disable: true), do: execute_service("disable")
  def process_args(start: true), do: execute_service("start")
  def process_args(stop: true), do: execute_service("stop")
  def process_args(enable: true), do: execute_service("enable")

  def process_args(_) do
    IO.puts("Welcome to the Sarx CLI!")
    print_help_message()
    receive_command()
  end

  defp execute_command("setup") do
    device_id = IO.gets("Please enter your device_id\ndevice_id: ") |> String.trim()
    device_secret = IO.gets("\nPlease enter your device_secret\ndevice_secret: ") |> String.trim()

    directory = get_directory()
    File.mkdir(directory)

    config_directory = Path.join([directory], "config")
    File.mkdir(config_directory)

    config_file = Path.join([config_directory], "config.srq")

    File.write(
      config,
      "device_id: #{device_id}\ndevice_secret: #{device_secret}"
    )

    sh_script_file = Path.join([config_directory], "sarqx.sh")

    File.write(
      sh_script_file,
      "#!/bin/bash\nif [[ \"$EUID\" != 0 ]]; then\necho $PASS | sudo -S -v\nif sudo true; then\nDIR_PATH=\"$(HOME)/sarqx\"\nmkdir $DIR_PATH\nsudo chmod 0066 $DIR_PATH\nsudo chown -R root:root $DIR_PATH\n/home/suro/Projects/sarx_umbrella/apps/sarx_reporter/sarx_reporter --connect\nfor i in {1..1000000}\ndo\nFILE_PATH=\"$(DIR_PATH)/$(date).srq\"\ntouch $FILE_PATH\nCONTENT=$(echo $PASS | sudo -S dmidecode)\necho $PASS | sudo -S echo -e $CONTENT >> $FILE_PATH\nsleep 5s # Change to 120s\ndone\nelse\necho \"Aborting script\"\nexit 1\nfi\nfi\nexit 0"
    )
  end

  defp execute_command("connect") do
    # HTTPoison.get("http://localhost:4000")
    # loop()
  end

  defp loop() do
    # Change to 2 minutes
    Process.sleep(5000)
    execute_command("connect")
  end

  defp execute_service(option) do
    System.shell("sudo systemctl #{option} sarqxd.service",
      env: [{"SUDO_ASKPASS", "./askpass.sh"}],
      into: IO.stream(:stdio, :line)
    )
  end

  defp get_directory() do
    {home, _} = System.shell("echo $HOME")
    Path.join(String.trim(home), "sarqx")
  end

  defp receive_command do
    IO.gets("\n> ")
    |> String.trim()
    |> String.downcase()
    |> run_command
  end

  defp run_command(_unknown) do
    IO.puts("\nInvalid command. I don't know what to do.")
    print_help_message()

    receive_command()
  end

  defp print_help_message do
    IO.puts("\nUsage: SarqX CLI [OPTION]")
    IO.puts("  --help \t display help message")
    IO.puts("  --status \t status application's demon")
    IO.puts("  --enable \t enable application's demon")
    IO.puts("  --disable \t disable application's demon")
    IO.puts("  --start \t start application's demon")
    IO.puts("  --stop \t stop application's demon")
    IO.puts("  --connect \t connect to the SarqX web-server")
  end
end
