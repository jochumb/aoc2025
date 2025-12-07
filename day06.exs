#! /usr/bin/env elixir

defmodule Day06 do

  def calculate(numbers, operators, acc\\0)
  def calculate(_, [], acc), do: acc
  def calculate(numbers, [o|os], acc) do
    {l, ts} = numbers |> Enum.reduce({[], []}, fn [h|t], {ns, ts} -> {ns ++ [h], ts ++ [t]} end)
    case o do
      "*" -> calculate(ts, os, acc + Enum.reduce(l, 1, fn n, r -> n * r end))
      "+" -> calculate(ts, os, acc + Enum.reduce(l, 0, fn n, r -> n + r end))
    end
  end

  def calculate_columns(numbers, operators, acc\\0)
  def calculate_columns(_, [], acc), do: acc
  def calculate_columns(numbers, [" "|os], acc), do: calculate_columns(numbers, os, acc)
  def calculate_columns(numbers, [o|os], acc) do
    {l, ts} = numbers |> parse_columns
    case o do
      "*" -> calculate_columns(ts, os, acc + Enum.reduce(l, 1, fn n, r -> n * r end))
      "+" -> calculate_columns(ts, os, acc + Enum.reduce(l, 0, fn n, r -> n + r end))
    end
  end

  defp parse_columns(numbers) do
    Enum.reduce_while(1..10000, {[], numbers}, fn _, {ns, ts} ->
      {n, cs} = parse_column(ts)
      if n == :halt do
        {:halt, {ns, cs}}
      else
        {:cont, {ns ++ [n], cs}}
      end
    end)
  end

  def parse_column([[]|_]), do: {:halt, []}
  def parse_column(numbers) do
    {l, ts} = numbers |> Enum.reduce({[], []}, fn [h|t], {ns, ts} -> {ns ++ [h], ts ++ [t]} end)
    case l |> List.to_string |> String.trim do
      "" -> {:halt, ts}
      s  -> {String.to_integer(s), ts}
    end
  end

end

[operators|numbers] = File.stream!("input/day06") |> Enum.map(&String.trim_trailing/1) |> Enum.map(&String.split/1) |> Enum.reverse
numbers |> Enum.map(&(Enum.map(&1, fn s -> String.to_integer(s) end))) |> Day06.calculate(operators) |> IO.inspect(label: "Part 1")

[operators|numbers] = File.stream!("input/day06") |> Enum.map(&(String.trim_trailing(&1, "\n"))) |> Enum.map(&String.graphemes/1) |> Enum.reverse
numbers |> Enum.reverse() |> Day06.calculate_columns(operators) |> IO.inspect(label: "Part 2")
