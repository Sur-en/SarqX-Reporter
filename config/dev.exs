import Config

config :logger, :console, format: "[$level] $message\n"

config :sarqx_reporter,
  server_host: "http://localhost:4000",
  path_to_credential_file: "#{File.cwd!()}/etc/credentials.json",
  secret: "14Ubf02J3f3T9erhP6xH095jG+t+HDVnBH5pbWx35JOKJg7OrYsLI4LJU8d1keVE",
  salt: "W28hwiH6xH095gG+t+HDVnbPVm2JrYsLI48d1qlOU",
  askpass: "#{File.cwd!()}/askpass.sh",
  daemon_name: "sarqxd-dev.service"
