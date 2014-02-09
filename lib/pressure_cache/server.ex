defmodule PressureCache.Server do
  use GenServer.Behaviour

  def start_link([cache, path]) do
    :gen_server.start_link({ :local, :pressure_cache }, __MODULE__, [cache, path], [])
  end

  def init([cache, path]) do
    :gen_event.add_handler(:erlfsmon_events, PressureCache.FileEvents, [self(), [cache, path]])
    { :ok, [cache, path] }
  end

  def handle_call(:cache, _from, [cache, path]) do
    { :reply, [cache, path], [cache, path] }
  end

  def handle_call({ :get, ckey }, _from, [cache, path]) do
    val = case :cherly.get(cache, :erlang.term_to_binary(ckey)) do
      {:ok, value } -> :erlang.binary_to_term(value)
      _             -> nil
    end
    { :reply, val, [cache, path] }
  end

  def handle_cast({ :put, ckey, value }, [cache, path]) do
    :cherly.put(cache, :erlang.term_to_binary(ckey), :erlang.term_to_binary(value))
    { :noreply, [cache, path] }
  end

  def handle_cast({ :delete, ckey }, [cache, path]) do
    :cherly.remove(cache, :erlang.term_to_binary(ckey))
    { :noreply, [cache, path] }
  end

end
