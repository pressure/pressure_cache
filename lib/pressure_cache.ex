defmodule PressureCache do
  use Application.Behaviour

  def start(_type, _args) do
    PressureCache.Supervisor.start_link( ConCache.start_link() )
  end

  def get(key) do
    :gen_server.call :pressure_cache, { :get, key }
  end

  def set(key, value) do
    :gen_server.cast :pressure_cache, { :put, key, value }
  end

  def del(key) do
    :gen_server.cast :pressure_cache, { :delete, key }
  end

  def cache do
    :gen_server.call :pressure_cache, :cache
  end
end
