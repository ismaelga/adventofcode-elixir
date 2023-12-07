defmodule AdventOfCode.Solution.Year2023.Day05 do
  def part1(input) do
    data = parse_data(input)

    data["seeds"]
    |> Enum.map(fn seed ->
      find_location(seed, data)
    end)
    |> Enum.sort()
    |> hd
  end

  def count_ranges(ranges) do
    ranges
    |> Enum.map(&Enum.count/1)
    |> Enum.sum()
  end

  def part2(input) do
    data = parse_data(input)

    max_concurrency = System.schedulers_online() * 2

    data["seeds"]
    |> Enum.chunk_every(2)
    |> Enum.map(fn [a, b] -> a..(a + b) end)
    |> Task.async_stream(
      fn range ->
        Stream.map(range, fn seed ->
          find_location(seed, data)
        end)
        |> Enum.reduce(:infinity, fn l, acc ->
          min(l, acc)
        end)
      end,
      max_concurrency: max_concurrency,
      timeout: :infinity
    )
    |> Enum.reduce(:infinity, fn {:ok, l}, acc ->
      min(l, acc)
    end)
  end

  def parse_data(input) do
    input
    |> String.split("\n")
    |> parse()
    |> Enum.into(%{})
  end

  def find_match(val, ranges) do
    case Enum.find(ranges, &(val in elem(&1, 0))) do
      {source, destination} ->
        steps = val - source.first
        destination.first + steps

      _ ->
        val
    end
  end

  def find_location(seed, data) do
    seed
    |> find_match(data["seed-to-soil"])
    |> find_match(data["soil-to-fertilizer"])
    |> find_match(data["fertilizer-to-water"])
    |> find_match(data["water-to-light"])
    |> find_match(data["light-to-temperature"])
    |> find_match(data["temperature-to-humidity"])
    |> find_match(data["humidity-to-location"])
  end

  def parse_numbers(line), do: line |> String.split() |> Enum.map(&String.to_integer/1)

  def parse_map(["" | rest]) do
    {[], rest}
  end

  def parse_map([line | rest]) do
    {map, rest} = parse_map(rest)

    [
      destination,
      source,
      range_length
    ] = parse_numbers(line)

    {[
       {source..(source + range_length), destination..(destination + range_length)}
       | map
     ], rest}
  end

  def parse([]) do
    []
  end

  def parse(["" | rest]) do
    parse(rest)
  end

  def parse(["seeds: " <> numbers | rest]) do
    [{"seeds", parse_numbers(numbers)} | parse(rest)]
  end

  def parse([seed_mapping | rest]) do
    [mapping | _] = String.split(seed_mapping, " ", trim: true)
    {map, rest} = parse_map(rest)
    [{mapping, map} | parse(rest)]
  end
end
