# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :gps_alerts,
  ecto_repos: [GpsAlerts.Repo]

# Configures the endpoint
config :gps_alerts, GpsAlertsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "o3dhYH0EKNW//fPkp8h9hBRi5G24SMUMIfqfX+LL6R5jq2OH6uRMAxzqZt3Pq/fs",
  render_errors: [view: GpsAlertsWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: GpsAlerts.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

config :gps_alerts, GpsAlerts.Scheduler,
  jobs: [
    {"*/5 * * * *", {GpsAlerts.Process, :processing_to_send, []}}
  ]

# config :gps_alerts, GpsAlerts.Mailer,
#  adapter: Bamboo.SendGridAdapter,
#  api_key: "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",
#  json_library: Jason

# config :my_app, GpsAlerts.Mailer, sandbox: true
