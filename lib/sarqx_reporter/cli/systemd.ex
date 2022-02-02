defmodule SarqXReporter.Systemd do
  def execute(option) do
    askpass_path =
      case System.get_env("MIX_ENV") do
        nil -> "/opt/sarqx-reporter/bin/askpass.sh"
        _ -> "#{File.cwd!()}/askpass.sh"
      end

    System.shell("sudo systemctl #{option} sarqxd.service",
      env: [{"SUDO_ASKPASS", askpass_path}],
      into: IO.stream(:stdio, :line)
    )
  end
end
