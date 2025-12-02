#! /usr/bin/env elixir

defmodule Day02 do
  def sum_valid_ids(ranges, acc\\0)
  def sum_valid_ids([], acc), do: acc
  def sum_valid_ids([range|tail], acc) do
    sum = range
      |> Enum.filter(&(valid_id(Integer.to_string(&1))))
      |> Enum.sum
    sum_valid_ids(tail, acc+sum)
  end

  defp valid_id(id) do
    length = String.length(id)
    if rem(length, 2) == 0 do
      {first, last} = String.split_at(id, div(length, 2))
      first == last
    else
      false
    end
  end

  def sum_valid_ids_alt(ranges, acc\\0)
  def sum_valid_ids_alt([], acc), do: acc
  def sum_valid_ids_alt([range|tail], acc) do
    sum = range
      |> Enum.filter(&(valid_id_alt(Integer.to_string(&1))))
      |> Enum.sum
    sum_valid_ids_alt(tail, acc+sum)
  end

  defp valid_id_alt(id) do
    case String.length(id) do
      1 -> false
      length -> 1..div(length,2)
        |> Enum.filter(&(rem(length, &1) == 0))
        |> Enum.map(&(valid_id_chunked(id, &1)))
        |> Enum.any?
    end
  end

  defp valid_id_chunked(id, chunk) do
    [head|tail] = Enum.chunk_every(String.graphemes(id), chunk)
    Enum.all?(tail, fn i -> i == head end)
  end
end


ranges = File.read!("input/day02")
  |> String.trim_trailing
  |> String.split(",")
  |> Enum.map(&(String.split(&1, "-")))
  |> Enum.map(fn [first,last] -> String.to_integer(first)..String.to_integer(last) end)

ranges |> Day02.sum_valid_ids |> IO.inspect(label: "Part 1")
ranges |> Day02.sum_valid_ids_alt |> IO.inspect(label: "Part 2")
