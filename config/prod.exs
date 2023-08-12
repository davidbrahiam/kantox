import Config

config :kantox, KantoxWeb.Endpoint,
  http: [port: 9091],
  debug_errors: false,
  server: true,
  code_reloader: false,
  check_origin: false

# Do not print debug messages in production
config :logger, level: :info
