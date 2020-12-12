defmodule Day10 do
  def run do
    gaps = Std.read_file_ints("input_files/day10.txt")
    |> Enum.sort
    |> Enum.map_reduce(0, fn(num, last) -> {num - last, num} end)
    |> elem(0)

    ones = gaps
    |> Enum.filter(fn x -> x == 1 end)
    |> length

    threes = gaps
    |> Enum.filter(fn x -> x == 3 end)
    |> length

    ones * (threes + 1)
  end

  def run2 do
    contents = Std.read_file_ints("input_files/day10.txt")
    contents = contents  ++ [Enum.max(contents) + 3]
    |> Enum.sort()
    |> Enum.chunk_while()
    |> Enum.map_reduce(0, fn(num, last) -> {num - last, num} end)
    

  end

  def valid_order?(adapters) do
    adapters
    |> Enum.map_reduce(0, fn(num, last) -> {num - last, num} end)
    |> elem(0)
    |> Enum.all?(fn x -> x > 3 || x < 0 end)
  end
end
