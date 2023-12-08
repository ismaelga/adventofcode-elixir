defmodule AdventOfCode.Solution.Year2023.Day08 do
  def part1(input) do
    {moves, parts} = parse(input)

    Stream.cycle(moves)
    |> Enum.reduce_while({"AAA", 0}, fn move, {current, count} ->
      case {move, Map.get(parts, current)} do
        {"R", {_, "ZZZ", _}} -> {:halt, count + 1}
        {"L", {"ZZZ", _, _}} -> {:halt, count + 1}
        {"R", {_, c, _}} -> {:cont, {c, count + 1}}
        {"L", {c, _, _}} -> {:cont, {c, count + 1}}
      end
    end)
  end

  def part2(input) do
    {moves, parts} = parse(input)

    init =
      parts
      |> Enum.filter(fn {_, {_, _, l}} -> l == "A" end)
      |> Enum.map(&elem(&1, 0))

    init
    |> Enum.map(fn init -> steps(init, moves, parts) end)
    |> Enum.reduce(fn a, b -> trunc(a * b / Integer.gcd(a, b)) end)
  end

  def steps(start, moves, parts) do
    Stream.cycle(moves)
    |> Enum.reduce_while({start, 0}, fn move, {current, count} ->
      case step(move, parts, current) do
        {:halt, _} -> {:halt, count}
        {:cont, c} -> {:cont, {c, count + 1}}
      end
    end)
  end

  def step(move, parts, current) do
    case {move, Map.get(parts, current)} do
      {"R", {_, c, "Z"}} -> {:halt, c}
      {"L", {c, _, "Z"}} -> {:halt, c}
      {"R", {_, c, _}} -> {:cont, c}
      {"L", {c, _, _}} -> {:cont, c}
    end
  end

  def parse(input) do
    [moves | parts] =
      input
      |> String.split("\n", trim: true)

    moves = moves |> String.split("", trim: true)
    parts = parse_parts(parts)
    {moves, parts}
  end

  def parse_parts(parts) do
    parts
    |> Enum.map(fn part ->
      [node, leafs] = part |> String.split("=", trim: true)

      [left, right] =
        leafs |> String.replace(["(", ")"], "") |> String.trim() |> String.split(", ", trim: true)

      node = node |> String.trim()
      last = node |> String.graphemes() |> List.last()
      {node, {left, right, last}}
    end)
    |> Enum.into(%{})
  end
end
