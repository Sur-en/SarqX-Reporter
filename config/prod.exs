import Config

config :logger, level: :info

config :sarqx_reporter, server_host: "https://sarqx.am"
config :sarqx_reporter, path_to_credential_file: "/etc/opt/sarqx-reporter/credentials.json"
