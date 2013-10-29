defmodule PressureCache.Helper do

  def iso_formatted_date_utc(erlang_date, offset // "") do
    case :calendar.local_time_to_universal_time_dst(erlang_date) do
      [] ->
        # illegal UTC date -> take local time instead
        iso_formatted_date(erlang_date, offset)
      [in_dst, post_dst] ->
        iso_formatted_date(in_dst) <> "Z / " <> iso_formatted_date(post_dst) <> "Z"
      [utc_date] ->
        iso_formatted_date(utc_date) <> "Z"
    end
  end

  def iso_formatted_date(erlang_date, offset // "") do
    [date,time] = lc e inlist tuple_to_list(erlang_date), do: tuple_to_list(e)
    (
      Enum.map_join(date, "-", &(String.rjust(integer_to_binary(&1), 2, ?0))) <> "T" <>
      Enum.map_join(time, ":", &(String.rjust(integer_to_binary(&1), 2, ?0))) <> offset
    )
  end

  def sanitize_path(path) when is_bitstring(path) do
    bitstring_to_list(path)
  end
  def sanitize_path(path) when is_list(path) do
    path
  end
  def sanitize_path(path) when is_atom(path) do
    path
  end
  def sanitize_path(_path) do
    throw(:wrong_type)
  end

end
