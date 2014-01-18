defmodule PressureCache.Mixfile do
  use Mix.Project

  def project do
    [
      app:     :pressure_cache,
      version: "0.1.0",
      elixir:  "~> 0.12.0",
      deps:    deps
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
