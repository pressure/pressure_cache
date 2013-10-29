defmodule PressureCache.Mixfile do
  use Mix.Project

  def project do
    [
      app: :pressure_cache,
      version: "0.0.1",
      elixir: "~> 0.10.3",
      deps: deps
    ]
  end

  def application do
    [
      mod: { PressureCache, [ watch_path: File.cwd! ] }
    ]
  end

  defp deps do
    [
      { :con_cache, github: "sasa1977/con_cache" },
      { :erlfsmon,  github: "proger/erlfsmon" }
    ]
  end
end
