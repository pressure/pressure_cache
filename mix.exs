defmodule PressureCache.Mixfile do
  use Mix.Project

  def project do
    [
      app:                   :pressure_cache,
      version:               "0.1.2",
      elixir:                "~> 0.12.3",
      build_per_environment: true,
      deps:                  deps
    ]
  end

  def application do
    [
      mod: { PressureCache, [] }
    ]
  end

  defp deps do
    [
      { :cherly,   github: "leo-project/cherly" },
      { :erlfsmon, github: "proger/erlfsmon" }
    ]
  end
end
