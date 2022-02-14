defmodule SarqXReporter.Systemd do
  @askpass Application.get_env(:sarqx_reporter, :askpass)
  @daemon_name Application.get_env(:sarqx_reporter, :daemon_name)

  def execute(option) do
    ["sudo systemctl", option, @daemon_name]
    |> make_command()
    |> System.shell(env: [{"SUDO_ASKPASS", @askpass}], into: IO.stream(:stdio, :line))
  end

  defp make_command(args), do: Enum.join(args, " ")
end
