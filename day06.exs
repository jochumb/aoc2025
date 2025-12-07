#! /usr/bin/env elixir

defmodule Day06 do

  def calculate(numbers, operators, acc\\0)
  def calculate(_, [], acc), do: acc
  def calculate(numbers, [o|os], acc) do
    {l, ts} = numbers |> Enum.reduce({[], []}, fn [h|t], {ns, ts} -> {ns ++ [h], ts ++ [t]} end)
    calculate(ts, os, acc + exec_op(l, o))
  end

  def calculate_columns(numbers, operators, acc\\0)
  def calculate_columns(_, [], acc), do: acc
  def calculate_columns(numbers, [" "|os], acc), do: calculate_columns(numbers, os, acc)
  def calculate_columns(numbers, [o|os], acc) do
    {l, ts} = numbers |> parse_columns
    calculate_columns(ts, os, acc + exec_op(l, o))
  end

  defp exec_op(l, "*"), do: Enum.reduce(l, 1, fn n, r -> n * r end)
  defp exec_op(l, "+"), do: Enum.reduce(l, 0, fn n, r -> n + r end)

  defp parse_columns(numbers, current\\[])
  defp parse_columns([], current), do: {current, []}
  defp parse_columns(numbers, current) do
    {l, ts} = numbers |> Enum.reduce({[], []}, &parse_column/2)
    case l |> List.to_string |> String.trim do
      "" -> {current, ts}
      s  -> parse_columns(ts, current ++ [String.to_integer(s)])
    end
  end

  defp parse_column([], acc), do: acc
  defp parse_column([h|t], {ns, ts}), do: {ns ++ [h], ts ++ [t]}

end

input = File.stream!("input/day06") |> Enum.map(&(String.trim_trailing(&1, "\n")))

[operators|numbers] = input |> Enum.map(&String.split/1) |> Enum.reverse
numbers |> Enum.map(&(Enum.map(&1, fn s -> String.to_integer(s) end))) |> Day06.calculate(operators) |> IO.inspect(label: "Part 1")

[operators|numbers] = input |> Enum.map(&String.graphemes/1) |> Enum.reverse
numbers |> Enum.reverse() |> Day06.calculate_columns(operators) |> IO.inspect(label: "Part 2")
