defmodule AdventOfCode.Solution.Year2023.Day01 do
  def part1(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn line ->
      digits = String.to_charlist(line) |> get_digits

      [digits |> Enum.reverse() |> hd, digits |> hd]
      |> List.to_integer()
    end)
    |> Enum.reduce(0, &(&1 + &2))
    |> IO.inspect(label: "Solution")
  end

  def part2(_input) do
  end

  def get_digits(list) do
    Enum.reduce(list, {[], []}, fn i, {acc, res} ->
      n =
        if i in ?0..?9 do
          i
        else
          case [i | acc] do
            [?o, ?r, ?e, ?z | _] -> ?0
            [?e, ?n, ?o | _] -> ?1
            [?o, ?w, ?t | _] -> ?2
            [?e, ?e, ?r, ?h, ?t | _] -> ?3
            [?r, ?u, ?o, ?f | _] -> ?4
            [?e, ?v, ?i, ?f | _] -> ?5
            [?x, ?i, ?s | _] -> ?6
            [?n, ?e, ?v, ?e, ?s | _] -> ?7
            [?t, ?h, ?g, ?i, ?e | _] -> ?8
            [?e, ?n, ?i, ?n | _] -> ?9
            _ -> nil
          end
        end

      res = if n, do: [n | res], else: res
      {[i | acc], res}
    end)
    |> elem(1)
  end
end
