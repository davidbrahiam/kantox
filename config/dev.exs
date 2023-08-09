import Config

config :kantox, KantoxWeb.Endpoint,
  url: [host: "localhost"],
  http: [port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "vIbG0SBnoZ2tSAAsQCXhiXteWTwysoRT1GbHa/npizb4n9d3sMYX1U9g4hHx93kX"


# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime
