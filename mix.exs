defmodule Geo.MixProject do
  use Mix.Project

  def project do
    [
      app: :geo,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :countries, :lib_lat_lon, :geocalc],
      applications: [:csv],
      mod: {Geo, []}
    ]
  end

  defp deps do
    [
      {:lib_lat_lon, "~> 0.4"},
      {:countries, "~> 1.6"},
      {:csv, "~> 1.4.2"},
      {:geocalc, "~> 0.8"}
    ]
  end
end
