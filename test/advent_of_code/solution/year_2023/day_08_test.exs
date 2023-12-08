defmodule AdventOfCode.Solution.Year2023.Day08Test do
  use ExUnit.Case, async: true

  import AdventOfCode.Solution.Year2023.Day08

  setup do
    [
      input: """
      LLR

      AAA = (BBB, BBB)
      BBB = (AAA, ZZZ)
      ZZZ = (ZZZ, ZZZ)
      """,
      input2: """
      LR

      11A = (11B, XXX)
      11B = (XXX, 11Z)
      11Z = (11B, XXX)
      22A = (22B, XXX)
      22B = (22C, 22C)
      22C = (22Z, 22Z)
      22Z = (22B, 22B)
      XXX = (XXX, XXX)
      """
    ]
  end

  test "part1", %{input: input} do
    result = part1(input)

    assert result == 6
  end

  test "part2", %{input2: input} do
    result = part2(input)

    assert result == 6
  end
end
