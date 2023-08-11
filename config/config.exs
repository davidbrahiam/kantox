# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

# Configures the endpoint
config :kantox, KantoxWeb.Endpoint,
  url: [host: "localhost"],
  http: [port: 4000],
  render_errors: [
    formats: [json: KantoxWeb.ErrorJSON],
    layout: false
  ],
  code_reloader: true,
  server: true

config :kantox, Kantox.Store, Kantox.Store.ETS

config :kantox, :default_table, :products

config :kantox, :warmers, [Kantox.Warmers.Product]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
