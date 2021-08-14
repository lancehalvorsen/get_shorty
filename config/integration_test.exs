use Mix.Config

config :get_shorty, GetShorty.Repo,
  username: "postgres",
  password: "postgres",
  database: "get_shorty_integration_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :get_shorty, GetShortyWeb.Endpoint,
  http: [port: 4010],
  server: true

config :logger, level: :warn