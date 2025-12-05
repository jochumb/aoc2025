#! /usr/bin/env elixir

defmodule Day05 do
  def count_fresh(ranges, ingredients) do
    ingredients |> Enum.filter(&(is_fresh?(&1, ranges))) |> Enum.count
  end

  defp is_fresh?(ingredient, ranges) do
    ranges |> Enum.any?(fn first..last//_ -> ingredient >= first and ingredient <= last end)
  end

  def total_fresh(ranges) do
    ranges
      |>  Enum.reduce_while(ranges, fn _, acc ->
            merged = merge_ranges_iter(acc)
            if length(merged) == length(acc) do
              {:halt, merged}
            else
              {:cont, merged}
            end
          end)
      |> Enum.map(&Range.size/1)
      |> Enum.sum
  end

  defp merge_ranges_iter(ranges, merged\\[])
  defp merge_ranges_iter([], merged), do: merged
  defp merge_ranges_iter([r|rs], acc) do
    {merged, unmerged} = merge_ranges(r, rs)
    merge_ranges_iter(unmerged, acc ++ [merged])
  end

  defp merge_ranges(merge, ranges, unmerged\\[])
  defp merge_ranges(merged, [], unmerged), do: {merged, unmerged}
  defp merge_ranges(merge, [r|rs], unmerged) do
    if Range.disjoint?(merge, r) do
      merge_ranges(merge, rs, unmerged ++ [r])
    else
      merge_ranges(join_2_ranges(merge, r), rs, unmerged)
    end
  end

  defp join_2_ranges(f1..l1//_, f2..l2//_), do: min(f1, f2)..max(l1, l2)

  def parse_input(inout, parsed\\{[], []})
  def parse_input([], parsed), do: parsed
  def parse_input([""|t], p), do: parse_input(t, p)
  def parse_input([h|t], {rs, is}) do
    if String.contains?(h, "-") do
      {from, to} = String.split(h, "-") |> Enum.map(&String.to_integer/1) |> List.to_tuple
      parse_input(t, {rs ++ [from..to], is})
    else
      parse_input(t, {rs, is ++ [String.to_integer(h)]})
    end
  end
end

{ranges, ingredients} = File.stream!("input/day05") |> Enum.map(&String.trim_trailing/1) |> Day05.parse_input

Day05.count_fresh(ranges, ingredients) |> IO.inspect(label: "Part 1")
Day05.total_fresh(ranges) |> IO.inspect(label: "Part 2")
