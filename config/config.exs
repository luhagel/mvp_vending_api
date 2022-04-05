# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :mvp_vending_api,
  ecto_repos: [MvpVendingApi.Repo],
  generators: [binary_id: true]

config :mvp_vending_api, MvpVendingApi.Repo, migration_primary_key: [name: :id, type: :binary_id]

# Configures the endpoint
config :mvp_vending_api, MvpVendingApiWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: MvpVendingApiWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: MvpVendingApi.PubSub,
  live_view: [signing_salt: "Sc1JEOuC"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :mvp_vending_api, MvpVendingApi.Guardian,
  issuer: "mvp_vending",
  secret_key: "WLJguAXZmwoMbOqMxBs1U/hMADjgGZYw4WcFV+9Y220QpfF0Yvnt1pBnSeijt7XA"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
