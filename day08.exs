#! /usr/bin/env elixir

defmodule Day08 do
  def product_3_circuits_after_n_connections(points, n\\1000) do
    points
      |> Enum.with_index(&({&2,&1}))
      |> distance_map
      |> Enum.sort(fn {_, d1}, {_, d2} -> d1 <= d2 end)
      |> Enum.take(n)
      |> Enum.map(fn {{ia, ib}, _} -> [ia|[ib]] end)
      |> merge_circuits
      |> Enum.map(&length/1)
      |> Enum.sort
      |> Enum.reverse
      |> Enum.take(3)
      |> Enum.reduce(1, &(&1 * &2))
  end

  def full_circuit(points) do
    ipoints = points |> Enum.with_index(&({&2,&1}))
    ipoints
      |> distance_map
      |> Enum.sort(fn {_, d1}, {_, d2} -> d1 <= d2 end)
      |> Enum.map(fn {{ia, ib}, _} -> [ia|[ib]] end)
      |> merge_all_circuits(length(ipoints))
      |> calc_wall_distance(ipoints)
  end

  defp distance_map(ipoints) do
    for {ia, a} <- ipoints,
        {ib, b} <- ipoints,
        ia < ib do
      distance(ia, a, ib, b)
    end
  end

  defp distance(ia, {ax, ay, az}, ib, {bx, by, bz}) do
    {{ia, ib}, :math.sqrt(Integer.pow(abs(ax-bx), 2) + Integer.pow(abs(ay-by), 2) + Integer.pow(abs(az-bz), 2))}
  end

  defp merge_circuits(paths, merged\\[])
  defp merge_circuits([], merged), do: merged
  defp merge_circuits([p|ps], []), do: merge_circuits(ps, [p])
  defp merge_circuits([p|ps], merged) do
    {rest, join} = merged |> Enum.split_with(&(MapSet.disjoint?(MapSet.new(&1), MapSet.new(p))))
    merge_circuits(ps, [Enum.uniq(List.flatten(join) ++ p)|rest])
  end

  defp merge_all_circuits(paths, point_count, merged\\[], final\\:none)
  defp merge_all_circuits([p|ps], pc, [], :none), do: merge_all_circuits(ps, pc, [p], p)
  defp merge_all_circuits([], _, _, final), do: final
  defp merge_all_circuits([p|ps], pc, merged, final) do
    if length(merged) == 1 and length(hd(merged)) == pc do
      final
    else
      {rest, join} = merged |> Enum.split_with(&(MapSet.disjoint?(MapSet.new(&1), MapSet.new(p))))
      merge_all_circuits(ps, pc, [Enum.uniq(List.flatten(join) ++ p)|rest], p)
    end
  end

  defp calc_wall_distance([ia|[ib|_]], ipoints) do
    map = Map.new(ipoints)
    {ax, _, _} = Map.get(map, ia)
    {bx, _, _} = Map.get(map, ib)
    ax * bx
  end
end

points = File.stream!("input/day08")
  |> Enum.map(&String.trim_trailing/1)
  |> Enum.map(fn r -> String.split(r, ",") |> Enum.map(&String.to_integer/1) |> List.to_tuple end)

points |> Day08.product_3_circuits_after_n_connections(1000) |> IO.inspect(label: "Part 1")
points |> Day08.full_circuit |> IO.inspect(label: "Part 2")
