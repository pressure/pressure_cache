defmodule PressureCache.Server do
  use GenServer.Behaviour

  alias ConCache,             as: CC
  alias PressureCache.Cache,  as: C
  alias PressureCache.File,   as: F
  alias PressureCache.Helper, as: H

  def start_link([cache, path]) do
    :gen_server.start_link({ :local, :pressure_cache }, __MODULE__, [cache, path], [])
  end

  def init([cache, path]) do
    :gen_event.add_handler(:erlfsmon_events, PressureCache.FileEvents, [self(), [cache, path]])
    spawn fn ->
      :timer.sleep(1500)
      prefill_check(path)
    end
    { :ok, [cache, path] }
  end

  def handle_call(:cache, _from, [cache, path]) do
    { :reply, [cache, path], [cache, path] }
  end

  def handle_call({ :get, ckey }, _from, [cache, path]) do
    val = CC.get(cache, ckey)
    { :reply, val, [cache, path] }
  end

  def handle_cast({ :put, ckey, value }, [cache, path]) do
    CC.put(cache, ckey , value)
    { :noreply, [cache, path] }
  end

  def handle_cast({ :delete, ckey }, [cache, path]) do
    CC.delete(cache, ckey)
    { :noreply, [cache, path] }
  end

  def prefill_check(path) do
    rprocs        = Process.registered
    cache_running = Enum.any?(rprocs, &(&1 == :pressure_cache))
    fsmon_running = Enum.any?(rprocs, &(&1 == :erlfsmon_events))
    eventhandlers = Enum.count(:gen_event.which_handlers(:erlfsmon_events)) > 0
    if cache_running && fsmon_running && eventhandlers do
      PressureCache.prefill_cache!(path)
    else
      :timer.sleep(500)
      prefill_check(path)
    end
  end

end
