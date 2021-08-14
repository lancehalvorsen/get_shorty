# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :get_shorty,
  ecto_repos: [GetShorty.Repo]

# Configures the endpoint
config :get_shorty, GetShortyWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Yr4zfLUYGlf11cLecBYTQXucdzMFKl6os2PcJoANl7qORbu/x/Gd57WEWGY81Ggx",
  render_errors: [view: GetShortyWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: GetShorty.PubSub,
  live_view: [signing_salt: "+5wFq/AN"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
