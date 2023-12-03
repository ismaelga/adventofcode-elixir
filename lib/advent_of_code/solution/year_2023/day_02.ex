defmodule AdventOfCode.Solution.Year2023.Day02 do
  def part1(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse_game/1)
    |> Enum.sum()
  end

  defp parse_game(line) do
    [id, rest] = line |> String.split(":")

    id = String.split(id, " ") |> Enum.at(1) |> String.to_integer()

    is_invalid =
      rest
      |> String.split(";")
      |> Enum.map(&parse_round/1)
      |> Enum.find(&invalid_round/1)

    if is_invalid do
      0
    else
      id
    end
  end

  defp parse_game_minimum(line) do
    [_id, rest] = line |> String.split(":")

    # id = String.split(id, " ") |> Enum.at(1) |> String.to_integer()

    rest
    |> String.split(";")
    |> Enum.map(&parse_round/1)
    |> Enum.reduce(%{"red" => 0, "green" => 0, "blue" => 0}, fn round, acc ->
      Enum.reduce(round, acc, fn {k, v}, acc ->
        Map.update!(acc, k, fn current ->
          max(current, v)
        end)
      end)
    end)
    |> Enum.map(&elem(&1, 1))
    |> Enum.reduce(&Kernel.*/2)
  end

  defp parse_round(l) do
    l
    |> String.split(", ")
    |> Enum.map(fn r ->
      [n, color] = String.trim(r) |> String.split(" ")
      {color, String.to_integer(n)}
    end)
    |> Enum.into(%{})
  end

  defp invalid_round(round) do
    Map.get(round, "red", 0) > 12 || Map.get(round, "green", 0) > 13 ||
      Map.get(round, "blue", 0) > 14
  end

  def part2(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse_game_minimum/1)
    |> Enum.sum()
  end
end
