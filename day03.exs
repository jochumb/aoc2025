#! /usr/bin/env elixir

defmodule Day03 do
  def max_joltage(banks, n\\2, sum\\0)
  def max_joltage([], _, sum), do: sum
  def max_joltage([bank|tail], n, sum) do
    batteries = String.graphemes(bank) |> Enum.map(&String.to_integer/1)
    max_joltage(tail, n, select_n_batteries(batteries, n) + sum)
  end

  defp select_n_batteries(batteries, n, acc\\[])
  defp select_n_batteries(_, 0, acc) do
    acc |> Enum.map(&Integer.to_string/1) |> List.to_string |> String.to_integer
  end
  defp select_n_batteries(bs, n, acc) do
    max = Enum.max(Enum.take(bs, Enum.count(bs) + 1 - n))
    remaining = Enum.drop_while(bs, &(&1 < max)) |> Enum.drop(1)
    select_n_batteries(remaining, n-1, acc ++ [max])
  end

end

banks = File.stream!("input/day03")
  |> Enum.map(&String.trim_trailing/1)

banks |> Day03.max_joltage |> IO.inspect(label: "Part 1")
banks |> Day03.max_joltage(12) |> IO.inspect(label: "Part 2")
