defmodule AdventOfCode.Solution.Year2023.Day03 do
  def part1(input) do
    lines =
      input
      |> String.trim()
      |> String.split("\n")

    valid_coords = parts_coords(lines)

    numbers = number_coords(lines)

    # valid_coords
    # |> Enum.map(fn {x, y} = coord ->
    #   {y, numbers |> Map.get(coord)}
    # end)
    # |> Enum.reject(fn {_, n} -> is_nil(n) end)
    # |> Enum.uniq()
    # |> Enum.map(&elem(&1, 1))
    # |> Enum.sum()

    for {line, i} <- input |> String.split("\n", trim: true) |> Enum.with_index(),
        [{start, len}] <- Regex.scan(~r'\d+', line, return: :index),
        Enum.any?(start..(start + len - 1), fn j -> {i, j} in valid_coords end) do
      line |> String.slice(start, len) |> String.to_integer()
    end
    |> Enum.sum()
  end

  def parts_coords(lines) do
    for {l, x} <- Enum.with_index(lines) do
      for {v, y} <- Enum.with_index(l |> String.to_charlist()) do
        if v != ?. and v not in ?0..?9 do
          adjacent_coords(x, y)
        end
      end
    end
    |> List.flatten()
    |> Enum.filter(fn i -> i end)
    |> Enum.into(MapSet.new())
  end

  def number_coords(lines) do
    for {l, x} <- Enum.with_index(lines) do
      {last_n, last_coords, res} =
        String.to_charlist(l)
        |> Enum.with_index()
        |> Enum.reduce({[], [], %{}}, fn
          {n, y}, {current, coords, acc} when n in ?0..?9 ->
            {[n | current], [{x, y} | coords], acc}

          _, {[], _, acc} ->
            {[], [], acc}

          _, {current, coords, acc} ->
            v = current |> Enum.reverse() |> List.to_integer()
            m = for coord <- coords, do: {coord, v}, into: %{}
            {[], [], Map.merge(acc, m)}
        end)

      case {last_n, last_coords} do
        {[], []} ->
          res

        _ ->
          v = last_n |> Enum.reverse() |> List.to_integer()
          m = for coord <- last_coords, do: {coord, v}, into: %{}
          Map.merge(res, m)
      end
    end
    |> Enum.reduce(&Map.merge/2)
  end

  def adjacent_coords(x, y) do
    [
      {x, y - 1},
      {x, y + 1},
      {x - 1, y},
      {x - 1, y - 1},
      {x - 1, y + 1},
      {x + 1, y},
      {x + 1, y - 1},
      {x + 1, y + 1}
    ]
  end

  def gears_coords(lines) do
    for {l, x} <- Enum.with_index(lines) do
      for {v, y} <- Enum.with_index(l |> String.to_charlist()) do
        if v == ?* do
          adjacent_coords(x, y)
        end
      end
    end
    |> Enum.concat()
    |> Enum.filter(fn i -> i end)
  end

  def part2(input) do
    lines =
      input
      |> String.split("\n", trim: true)

    coords =
      gears_coords(lines)

    Enum.with_index(lines)
    |> Enum.reduce(%{}, fn {line, i}, acc ->
      Regex.scan(~r'\d+', line, return: :index)
      |> Enum.reduce(acc, fn [{start, len}], acc ->
        range = start..(start + len - 1)

        coords
        |> Enum.reduce(acc, fn coord, acc ->
          if Enum.any?(range, fn j -> {i, j} in coord end) do
            n = line |> String.slice(start, len) |> String.to_integer()
            c = Map.get(acc, coord, [])
            Map.put(acc, coord, [n | c])
          else
            acc
          end
        end)
      end)
    end)
    |> Map.values()
    |> Enum.map(fn
      [a, b] ->
        a * b

      _ ->
        0
    end)
    |> Enum.filter(& &1)
    |> Enum.sum()
  end
end
