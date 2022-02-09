import Config

config :logger, :console, format: "[$level] $message\n"

config :sarqx_reporter, server_host: "http://localhost:4000"
config :sarqx_reporter, path_to_credential_file: "#{File.cwd!()}/etc/credentials.json"
