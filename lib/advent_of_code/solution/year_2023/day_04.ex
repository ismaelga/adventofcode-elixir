defmodule AdventOfCode.Solution.Year2023.Day04 do
  def part1(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_card/1)
    |> Enum.map(&elem(&1, 1))
    |> Enum.sum()
  end

  def parse_card(line) do
    [card_number, numbers] = String.split(line, ":", trim: true)

    [winning, numbers] =
      numbers
      |> String.split("|", trim: true)

    winning = winning |> String.split() |> Enum.map(&String.to_integer/1)
    numbers = numbers |> String.split() |> Enum.map(&String.to_integer/1)

    score =
      Enum.filter(numbers, &(&1 in winning))
      |> Enum.count()

    s =
      if score < 2 do
        score
      else
        :math.pow(2, score - 1)
      end

    ["Card", n] = card_number |> String.split(" ", trim: true)
    {String.to_integer(n), s |> round(), score}
  end

  def part2(input) do
    cards =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&parse_card/1)
      |> Enum.map(&{elem(&1, 0), elem(&1, 2)})
      |> Enum.into([])

    orig =
      Enum.map(cards, &{elem(&1, 0), 1})
      |> Enum.into(%{})

    last = orig |> Enum.count()

    cards
    |> Enum.reduce(orig, fn {i, gives}, acc ->
      n = Map.get(acc, i)

      if gives >= 1 do
        (i + 1)..(i + gives)
        |> Enum.reduce(acc, fn c, acc ->
          if c > last do
            acc
          else
            Map.update(acc, c, nil, &(&1 + n))
          end
        end)
      else
        acc
      end
    end)
    |> Map.values()
    |> Enum.sum()
  end
end
