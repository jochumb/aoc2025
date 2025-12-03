#! /usr/bin/env elixir

defmodule Day03 do
  def max_joltage(banks, n\\2, sum\\0)
  def max_joltage([], _, sum), do: sum
  def max_joltage([bank|tail], n, sum) do
    bank
      |> String.graphemes
      |> Enum.map(&String.to_integer/1)
      |> select_n_batteries(n)
      |> (&(max_joltage(tail, n, &1 + sum))).()
  end

  defp select_n_batteries(batteries, n, acc\\[])
  defp select_n_batteries(_, 0, acc) do
    acc |> Enum.map(&Integer.to_string/1) |> List.to_string |> String.to_integer
  end
  defp select_n_batteries(bs, n, acc) do
    selected = bs |> Enum.take(Enum.count(bs) + 1 - n) |> Enum.max
    bs
      |> Enum.drop_while(&(&1 < selected))
      |> Enum.drop(1)
      |> select_n_batteries(n-1, acc ++ [selected])
  end
end

banks = File.stream!("input/day03") |> Enum.map(&String.trim_trailing/1)

banks |> Day03.max_joltage |> IO.inspect(label: "Part 1")
banks |> Day03.max_joltage(12) |> IO.inspect(label: "Part 2")
