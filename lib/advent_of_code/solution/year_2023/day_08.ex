defmodule AdventOfCode.Solution.Year2023.Day08 do
  def part1(input) do
    [moves | parts] =
      input
      |> String.split("\n", trim: true)

    moves = moves |> String.split("", trim: true)
    parts = parse_parts(parts)

    Stream.cycle(moves)
    |> Enum.reduce_while({"AAA", 0}, fn move, {current, count} ->
      case {move, Map.get(parts, current)} do
        {"R", {_, "ZZZ"}} -> {:halt, count + 1}
        {"L", {"ZZZ", _}} -> {:halt, count + 1}
        {"R", {_, c}} -> {:cont, {c, count + 1}}
        {"L", {c, _}} -> {:cont, {c, count + 1}}
      end
    end)
  end

  def part2(_input) do
  end

  def parse_parts(parts) do
    parts
    |> Enum.map(fn part ->
      [node, leafs] = part |> String.split("=", trim: true)

      [left, right] =
        leafs |> String.replace(["(", ")"], "") |> String.trim() |> String.split(", ", trim: true)

      {node |> String.trim(), {left, right}}
    end)
    |> Enum.into(%{})
  end
end
