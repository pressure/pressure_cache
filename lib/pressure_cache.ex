defmodule PressureCache do
  use Application.Behaviour

  alias ConCache,             as: CC
  alias PressureCache.Cache,  as: C
  alias PressureCache.File,   as: F
  alias PressureCache.Helper, as: H

  def start(_type, _args) do
    cache      = CC.start_link()
    watch_path = File.cwd!
    File.mkdir_p(watch_path)
    IO.puts "[PressureCache] Watching files in #{watch_path} ..."
    PressureCache.Supervisor.start_link( [cache, watch_path] )
  end

  def get(key),        do: C.get(key)
  def set(key, value), do: C.set(key, value)
  def del(key),        do: C.del(key)

  def prefill_cache!(path) do
    files = Path.wildcard(Path.absname(H.sanitize_path(path)) ++ '/**/*')
    files |> Enum.each fn(f)->
      { :ok, fstat } = File.stat(f, [time: :universal])
      if fstat.type == :regular do F.read(f) end
    end
  end

end
