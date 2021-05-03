# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :starwarx, StarwarxWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "mMSYNSyreqstZHaSc6S9deOAQjQMklzcd+rT58VCJUYPtaPPBKTZ/UOLHRX5nKpw",
  render_errors: [view: StarwarxWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Starwarx.PubSub,
  live_view: [signing_salt: "pMJf1iG+"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configures the space
config :starwarx, :space, width: 2_000, height: 400

# Configures the stars populator
config :starwarx, Starwarx.Star.Populator, initial_mode: 50, started_mode: 1

# Configures the spaceship
config :starwarx, :spaceship, width: 29, height: 68, initial_position: {100, 200}

# Configures the enemy
config :starwarx, :enemy, width: 21, height: 34

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
