defmodule PressureCache.Server do
  use GenServer.Behaviour

  def start_link(cache) do
    :gen_server.start_link({ :local, :pressure_cache }, __MODULE__, cache, [])
  end

  def init(cache) do
    { :ok, cache }
  end

  def handle_call(:cache, _from, cache) do
    { :reply, cache, cache }
  end

  def handle_call({ :get, ckey }, _from, cache) do
    val = ConCache.get(cache, ckey)
    { :reply, val, cache }
  end

  def handle_cast({ :put, ckey, value }, cache) do
    ConCache.put(cache, ckey , value)
    { :noreply, cache }
  end

  def handle_cast({ :delete, ckey }, cache) do
    ConCache.delete(cache, ckey)
    { :noreply, cache }
  end

end
