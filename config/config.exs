use Mix.Config

config :scrum2000, [
  http_provider: HTTPoison,
]

if File.exists?("config/config.secret.exs"), do: import_config "config.secret.exs"
