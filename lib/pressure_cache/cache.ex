defmodule PressureCache.Cache do

  def get(key),        do: :gen_server.call(:pressure_cache, { :get, key })
  def set(key, value), do: :gen_server.cast(:pressure_cache, { :put, key, value })
  def del(key),        do: :gen_server.cast(:pressure_cache, { :delete, key })
  def cache_and_path,  do: :gen_server.call(:pressure_cache, :cache)
  def cache,           do: hd(cache_and_path)
  def path,            do: hd(Enum.reverse(cache_and_path))
  def memory,          do: ConCache.memory(cache)

end
