defmodule PressureCache.FileEvents do
  use GenEvent.Behaviour

  def init([pid,cache]) do
    { :ok, [pid,cache] }
  end

  def handle_event({ _epid, {:erlfsmon, :file_event}, { path, events } }, [pid,cache]) do
    is_modified = Enum.any?(events, fn(e)-> e == :modified end)
    is_renamed  = Enum.any?(events, fn(e)-> e == :renamed end)
    if is_modified || is_renamed do
      PressureCache.File.read_and_cache(path)
    end
    { :ok, [pid,cache] }
  end

  def handle_event(_message, [pid,cache]) do
    { :ok, [pid,cache] }
  end
end
