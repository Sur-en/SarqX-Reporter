import Config

config :logger, level: :info

config :sarqx_reporter,
  server_host: "https://sarqx.am",
  path_to_credential_file: "/etc/opt/sarqx-reporter/credentials.json",
  secret: "27Ubf02J3f3T9erhXgxH035jG+t+HDVnBH5pbWx35JOYJg7OrTsLI4LNU8d2mePE",
  salt: "B14jyrQ6xH095gG+t+TDVnbPVm4KrYsLU48d1olOU",
  askpass: "/opt/sarqx-reporter/bin/askpass.sh",
  daemon_name: "sarqxd.service"
