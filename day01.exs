#! /usr/bin/env elixir

defmodule Day01 do
  def rotate(rotations, position\\50, count\\0)
  def rotate([], _, count), do: count
  def rotate([{direction, distance}|tail], position, count) do
    single = rem(distance, 100)
    next_pos = case direction do
      "L" -> position - single
      "R" -> position + single
    end
    case next_pos do
      x when x < 0    -> rotate(tail, x + 100, count)
      x when x > 100  -> rotate(tail, x - 100, count)
      0               -> rotate(tail, 0, count + 1)
      100             -> rotate(tail, 0, count + 1)
      _               -> rotate(tail, next_pos, count)
    end
  end

  def rotate_alt(rotations, position\\50, count\\0)
  def rotate_alt([], _, count), do: count
  def rotate_alt([{direction, distance}|tail], position, count) do
    single = rem(distance, 100)
    incr = case single do
      ^distance -> 0
      _         -> div(distance-single, 100)
    end
    next_pos = case direction do
      "L" when position == 0 -> 100 - single
      "L" -> position - single
      "R" -> position + single
    end
    case next_pos do
      x when x < 0   -> rotate_alt(tail, x + 100, count + incr + 1)
      x when x > 100 -> rotate_alt(tail, x - 100, count + incr + 1)
      0              -> rotate_alt(tail, 0, count + incr + 1)
      100            -> rotate_alt(tail, 0, count + incr + 1)
      _              -> rotate_alt(tail, next_pos, count + incr)
    end
  end
end

rotatations = File.stream!("input/day01")
  |> Stream.map(&String.trim_trailing/1)
  |> Stream.map(&(String.split_at(&1, 1)))
  |> Enum.map(fn {x,y} -> {x,String.to_integer(y)} end)

rotatations |> Day01.rotate |> IO.inspect(label: "Part 1")
rotatations |> Day01.rotate_alt |> IO.inspect(label: "Part 2")
