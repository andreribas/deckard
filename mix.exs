defmodule Scrum2000.MixProject do
  use Mix.Project

  def project do
    [
      app: :scrum2000,
      version: "0.1.0",
      elixir: "~> 1.8",
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
      {:httpoison, "~> 1.5"},
      {:jason, "~> 1.1"},
    ]
  end
end
