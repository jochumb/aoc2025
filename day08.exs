#! /usr/bin/env elixir

defmodule Day08 do
  def product_3_circuits_for_n_edges(nodes, n\\1000) do
    nodes
      |> sorted_edges
      |> Enum.take(n)
      |> merge_circuits
      |> Enum.map(&length/1)
      |> Enum.sort
      |> Enum.reverse
      |> Enum.take(3)
      |> Enum.reduce(1, &(&1 * &2))
  end

  def full_circuit(nodes) do
    nodes
      |> sorted_edges
      |> merge_all_circuits(length(nodes))
      |> calc_wall_distance(Map.new(nodes))
  end

  defp sorted_edges(nodes) do
    for {ia, a} <- nodes,
        {ib, b} <- nodes,
        ia < ib do
      distance(ia, a, ib, b)
    end
      |> Enum.sort(fn {_, d1}, {_, d2} -> d1 <= d2 end)
      |> Enum.map(fn {{ia, ib}, _} -> [ia|[ib]] end)
  end

  defp distance(ia, {ax, ay, az}, ib, {bx, by, bz}) do
    {{ia, ib}, :math.sqrt(Integer.pow(abs(ax-bx), 2) + Integer.pow(abs(ay-by), 2) + Integer.pow(abs(az-bz), 2))}
  end

  defp merge_circuits(edges, circuits\\[])
  defp merge_circuits([], circuits), do: circuits
  defp merge_circuits([e|es], []), do: merge_circuits(es, [e])
  defp merge_circuits([e|es], circuits), do: merge_circuits(es, merge_edge(e, circuits))

  defp merge_all_circuits(edges, node_count, circuits\\[], final\\:none)
  defp merge_all_circuits([e|es], nc, [], _), do: merge_all_circuits(es, nc, [e], e)
  defp merge_all_circuits(_, nc, [c|[]], final) when length(c) == nc, do: List.to_tuple(final)
  defp merge_all_circuits([e|es], nc, circuits, _), do: merge_all_circuits(es, nc, merge_edge(e, circuits), e)

  defp merge_edge(edge, circuits) do
    {rest, to_merge} = circuits |> Enum.split_with(&(MapSet.disjoint?(MapSet.new(&1), MapSet.new(edge))))
    [Enum.uniq(List.flatten(to_merge) ++ edge)|rest]
  end

  defp calc_wall_distance({ia, ib}, nodes), do: elem(nodes[ia], 0) * elem(nodes[ib], 0)
end

nodes = File.stream!("input/day08")
  |> Enum.map(&String.trim_trailing/1)
  |> Enum.map(fn r -> String.split(r, ",") |> Enum.map(&String.to_integer/1) |> List.to_tuple end)
  |> Enum.with_index(&({&2,&1}))

nodes |> Day08.product_3_circuits_for_n_edges |> IO.inspect(label: "Part 1")
nodes |> Day08.full_circuit |> IO.inspect(label: "Part 2")
