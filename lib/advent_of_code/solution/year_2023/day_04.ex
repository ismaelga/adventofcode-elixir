defmodule AdventOfCode.Solution.Year2023.Day04 do
  def part1(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_card/1)
    |> Enum.sum()
  end

  def parse_card(line) do
    [_, numbers] = String.split(line, ":")

    [winning, numbers] =
      numbers
      |> String.split("|", trim: true)

    winning = winning |> String.split() |> Enum.map(&String.to_integer/1)
    numbers = numbers |> String.split() |> Enum.map(&String.to_integer/1)

    score =
      Enum.filter(numbers, &(&1 in winning))
      |> Enum.count()

    if score < 2 do
      score
    else
      :math.pow(2, score - 1)
    end
  end

  def part2(_input) do
  end
end
