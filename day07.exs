#! /usr/bin/env elixir

defmodule Day07 do

  def count_splits(rows, beams\\[], splits\\0)
  def count_splits([], _, splits), do: splits
  def count_splits([r|rs], beams, splits) do
    if String.contains?(r, "S") do
      count_splits(rs, [String.length(hd(String.split(r, "S")))], splits)
    else
      {bs, c} = Enum.reduce(beams, {[], 0}, fn beam, {bs, c} ->
        if String.at(r, beam) == "^" do
          {bs ++ [beam - 1|[beam + 1]], c + 1}
        else
          {bs ++ [beam], c}
        end
      end)
      count_splits(rs, Enum.uniq(bs), splits + c)
    end
  end

  def count_timelines(rows, timelines\\%{})
  def count_timelines([], timelines), do: timelines |> Map.values |> Enum.sum
  def count_timelines([r|rs], timelines) do
    if String.contains?(r, "S") do
      count_timelines(rs, %{String.length(hd(String.split(r, "S"))) => 1})
    else
      ts = timelines |> Map.to_list |> Enum.reduce(%{}, fn {i, c}, acc ->
        if String.at(r, i) == "^" do
          Map.merge(acc, %{i-1 => c, i+1 => c}, fn _k, v1, v2 -> v1 + v2 end)
        else
          Map.merge(acc, %{i => c}, fn _k, v1, v2 -> v1 + v2 end)
        end
      end)
      count_timelines(rs, ts)
    end
  end

end

rows = File.stream!("input/day07") |> Enum.map(&String.trim_trailing/1) |> Enum.take_every(2)

rows |> Day07.count_splits |> IO.inspect(label: "Part 1")
rows |> Day07.count_timelines |> IO.inspect(label: "Part 2")
