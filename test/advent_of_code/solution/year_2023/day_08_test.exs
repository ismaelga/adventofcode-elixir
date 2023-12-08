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
      """
    ]
  end

  test "part1", %{input: input} do
    result = part1(input)

    assert result == 6
  end

  @tag :skip
  test "part2", %{input: input} do
    result = part2(input)

    assert result
  end
end
