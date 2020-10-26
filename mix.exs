defmodule Deckard.MixProject do
  use Mix.Project

  def project do
    [
      app: :deckard,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: true,
      deps: deps(),
    ]
  end

  def application do
    [
      extra_applications: [:logger],
    ]
  end

  defp deps do
    [
      {:httpoison, "~> 1.7"},
      {:jason, "~> 1.2"},
    ]
  end
end
