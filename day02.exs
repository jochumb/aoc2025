#! /usr/bin/env elixir

defmodule Day02 do
  def sum_valid_ids(ranges, validate_f\\&validate_2/1, acc\\0)
  def sum_valid_ids([], _, acc), do: acc
  def sum_valid_ids([range|tail], f, acc) do
    sum = range
      |> Enum.filter(&(f.(Integer.to_string(&1))))
      |> Enum.sum
    sum_valid_ids(tail, f, acc+sum)
  end

  def validate_2(id) do
    length = String.length(id)
    if rem(length, 2) == 0 do
      {first, last} = String.split_at(id, div(length, 2))
      first == last
    else
      false
    end
  end

  def validate_any(id) do
    case String.length(id) do
      1 -> false
      length -> 1..div(length,2)
        |> Enum.filter(&(rem(length, &1) == 0))
        |> Enum.map(&(validate_with_chunks(id, &1)))
        |> Enum.any?
    end
  end

  defp validate_with_chunks(id, chunk_size) do
    [head|tail] = Enum.chunk_every(String.graphemes(id), chunk_size)
    Enum.all?(tail, fn i -> i == head end)
  end
end

ranges = File.read!("input/day02")
  |> String.trim_trailing
  |> String.split(",")
  |> Enum.map(&(String.split(&1, "-")))
  |> Enum.map(fn [first,last] -> String.to_integer(first)..String.to_integer(last) end)

ranges |> Day02.sum_valid_ids |> IO.inspect(label: "Part 1")
ranges |> Day02.sum_valid_ids(&Day02.validate_any/1) |> IO.inspect(label: "Part 2")
