use Mix.Config

config :deckard, [
  http_provider: HTTPoison,
  worked_hours: fn -> Enum.take_random(4..6, 1) |> Enum.at(0) end
]

if File.exists?("config/config.secret.exs"), do: import_config "config.secret.exs"
