defmodule SarqXReporter.Systemd do
  def execute(option) do
    askpass_path =
      case System.get_env("MIX_ENV") do
        nil -> "/opt/sarqx-reporter/bin/askpass.sh"
        _ -> "#{File.cwd!()}/askpass.sh"
      end

    daemon_name =
      case System.get_env("MIX_ENV") do
        nil -> "/etc/systemd/system/sarqxd.service"
        _ -> "/etc/systemd/system/sarqxd-dev.service"
      end

    System.shell("sudo systemctl #{option} #{daemon_name}",
      env: [{"SUDO_ASKPASS", askpass_path}],
      into: IO.stream(:stdio, :line)
    )
  end
end
