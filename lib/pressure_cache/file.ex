defmodule PressureCache.File do
  # Use cached file first or fallback to read and cache

  # Implement http://elixir-lang.org/docs/stable/File.html

  alias PressureCache.Cache,  as: C
  alias PressureCache.Helper, as: H

  defdelegate cd(path),        to: File
  defdelegate cd!(path),       to: File
  defdelegate cd!(path, func), to: File

  defdelegate chgrp(file, gid),  to: File
  defdelegate chgrp!(file, gid), to: File

  defdelegate chmod(file, mode),  to: File
  defdelegate chmod!(file, mode), to: File

  defdelegate chown(file, uid),  to: File
  defdelegate chown!(file, uid), to: File

  defdelegate close!(io_device), to: File

  defdelegate copy(source, destination),               to: File
  defdelegate copy(source, destination, bytes_count),  to: File
  defdelegate copy!(source, destination),              to: File
  defdelegate copy!(source, destination, bytes_count), to: File

  defdelegate cp(source, destination),              to: File
  defdelegate cp(source, destination, callback),    to: File
  defdelegate cp!(source, destination),             to: File
  defdelegate cp!(source, destination, callback),   to: File

  defdelegate cp_r(source, destination),            to: File
  defdelegate cp_r(source, destination, callback),  to: File
  defdelegate cp_r!(source, destination),           to: File
  defdelegate cp_r!(source, destination, callback), to: File

  defdelegate cwd,  to: File
  defdelegate cwd!, to: File

  defdelegate dir?(path), to: File

  defdelegate exists?(path), to: File

  defdelegate ls(),     to: File
  defdelegate ls(path), to: File
  defdelegate ls!(),    to: File
  defdelegate ls!(dir), to: File

  defdelegate mkdir(path),  to: File
  defdelegate mkdir!(path), to: File

  defdelegate mkdir_p(path),  to: File
  defdelegate mkdir_p!(path), to: File

  defdelegate open(path),                   to: File
  defdelegate open(path, modes),            to: File
  defdelegate open(path, modes, function),  to: File
  defdelegate open!(path),                  to: File
  defdelegate open!(path, modes),           to: File
  defdelegate open!(path, modes, function), to: File

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

  defdelegate regular?(path), to: File

  defdelegate rm(path),  to: File
  defdelegate rm!(path), to: File

  defdelegate rm_rf(path),  to: File
  defdelegate rm_rf!(path), to: File
  defdelegate rmdir(path),  to: File
  defdelegate rmdir!(path), to: File

  defdelegate stat(path),        to: File
  defdelegate stat(path, opts),  to: File
  defdelegate stat!(path),       to: File
  defdelegate stat!(path, opts), to: File

  defdelegate stream!(path),                       to: File
  defdelegate stream!(path, modes),                to: File
  defdelegate stream!(path, modes, line_or_bytes), to: File

  defdelegate stream_to!(stream, path),        to: File
  defdelegate stream_to!(stream, path, modes), to: File

  defdelegate touch(path),        to: File
  defdelegate touch(path, time),  to: File
  defdelegate touch!(path),       to: File
  defdelegate touch!(path, time), to: File

  defdelegate write(path, content),         to: File
  defdelegate write(path, content, modes),  to: File
  defdelegate write!(path, content),        to: File
  defdelegate write!(path, content, modes), to: File

  defdelegate write_stat(path, stat),        to: File
  defdelegate write_stat(path, stat, opts),  to: File
  defdelegate write_stat!(path, stat),       to: File
  defdelegate write_stat!(path, stat, opts), to: File

  # privates

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
