defmodule AdventOfCode.Solution.Year2023.Day06 do
  def part1(input) do
    races = parse_races(input, :split)

    Enum.map(races, &better_records/1)
    |> Enum.reduce(&Kernel.*/2)
  end

  def part2(input) do
    races = parse_races(input, :join)

    Enum.map(races, &better_records/1)
    |> Enum.reduce(&Kernel.*/2)
  end

  def better_records({time, distance}) do
    1..(time - 1)
    |> Enum.filter(fn t ->
      (time - t) * t > distance
    end)
    |> Enum.count()
  end

  def parse_races(input, variance) do
    ["Time:" <> times, "Distance:" <> distances] = String.split(input, "\n", trim: true)

    times = parse_numbers(times, variance)
    distances = parse_numbers(distances, variance)

    Enum.zip(times, distances)
  end

  defp parse_numbers(i, :split),
    do: String.split(i, " ", trim: true) |> Enum.map(&String.to_integer/1)

  defp parse_numbers(i, :join),
    do: String.split(i, " ", trim: true) |> Enum.join() |> String.to_integer() |> List.wrap()
end
