import Config

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

config :sarqx_reporter, server_host: "http://localhost:4000"
