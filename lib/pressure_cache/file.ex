defmodule PressureCache.File do
  # Use cached file first or fallback to read and cache

  # Implement http://elixir-lang.org/docs/stable/File.html

  alias PressureCache.Cache,  as: C
  alias PressureCache.Helper, as: H

  def cd(path),  do: File.cd(path)
  def cd!(path), do: File.cd!(path)
  def cd!(path,func), do: File.cd!(path,func)

  def cwd,  do: File.cwd
  def cwd!, do: File.cwd!


  def stat(path, opts // []),  do: File.stat(path, opts)
  def stat!(path, opts // []), do: File.stat!(path, opts)


  def read(path) do
    spath = H.sanitize_path(path)
    data  = C.get [file: spath]
    if data do
      { :ok, data }
    else
      read_and_cache(spath)
    end
  end

  def read!(path) do
    case read(path) do
      { :ok, data } -> data
      { :error, e } -> throw(e)
    end
  end

  def read_and_cache(path) do
    case File.read(H.sanitize_path(path)) do
      { :ok, data } ->
        C.set([file: path], data)
        { :ok, data }
      { :error, msg } ->
        { :error, msg }
    end
  end

end
