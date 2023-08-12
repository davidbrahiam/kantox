import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :kantox, KantoxWeb.Endpoint,
  http: [host: "localhost", port: 4002],
  secret_key_base: "PoFgbDzLiSeX7WQU/6CxdswpP9lNjpTiCUCiRK3mKUVjwU2U7lGey+NTcXLUpTth",
  server: false,
  code_reloader: false

config :kantox, Kantox.Store, Kantox.Store.Mock

config :kantox, :warmers, []
config :kantox, :charts, []

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
