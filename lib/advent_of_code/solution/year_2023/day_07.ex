defmodule AdventOfCode.Solution.Year2023.Day07 do
  @cards_rank String.to_charlist("AKQT98765432J")
              |> Enum.reverse()
              |> Enum.with_index()
              |> Enum.into(%{})

  def part1(input) do
    String.split(input, "\n", trim: true)
    |> Enum.map(&String.split(&1, " ", trim: true))
    |> ranked
  end

  def part2(input) do
    String.split(input, "\n", trim: true)
    |> Enum.map(&String.split(&1, " ", trim: true))
    |> ranked(true)
  end

  def ranked(hands, joker \\ false) do
    hands
    |> Enum.map(fn [card, score] ->
      {card, card_to_points(card, joker), score}
    end)
    |> Enum.sort(fn {card1, points1, _}, {card2, points2, _} ->
      if points1 == points2 do
        compare_in_order(card1, card2)
      else
        points1 > points2
      end
    end)
    |> Enum.reverse()
    |> Enum.with_index()
    |> Enum.map(fn {{_, _, score}, idx} ->
      String.to_integer(score) * (idx + 1)
    end)
    |> Enum.sum()
  end

  def compare_in_order([], []), do: true

  def compare_in_order([c1 | rest1], [c2 | rest2]) when c1 == c2 do
    compare_in_order(rest1, rest2)
  end

  def compare_in_order([c1 | _], [c2 | _]) do
    @cards_rank[c1] >
      @cards_rank[c2]
  end

  def compare_in_order(card1, card2) do
    compare_in_order(card1 |> String.to_charlist(), card2 |> String.to_charlist())
  end

  def card_to_points(card, joker) do
    freqs =
      String.split(card, "", trim: true)
      |> Enum.frequencies()

    freqs =
      if joker && freqs["J"] do
        {c, f} = Map.pop(freqs, "J")

        if c == 5 do
          %{"A" => 5}
        else
          {k, v} =
            Enum.sort_by(f, &elem(&1, 1), :desc)
            |> hd

          Map.put(f, k, v + c)
        end
      else
        freqs
      end

    case freqs
         |> Map.values()
         |> Enum.sort(:desc) do
      [5 | _] -> 10
      [4 | _] -> 9
      [3, 2 | _] -> 8
      [3 | _] -> 7
      [2, 2 | _] -> 6
      [2 | _] -> 5
      _ -> 1
    end
  end
end
