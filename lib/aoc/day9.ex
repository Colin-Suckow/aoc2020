defmodule Day9 do
  def run do
    contents = Std.read_file_ints("input_files/day9.txt")

    contents
    |> Enum.with_index()
    |> Enum.slice(25..length(contents))
    |> Enum.filter(fn {x, index} -> Enum.member?(calculate_valid_map(Enum.slice(contents, index-25..index-1)), x) == false end)
    |> List.first()
    |> elem(0)
  end

  def run2() do
    contents = Std.read_file_ints("input_files/day9.txt")
    indexed_contents = contents
    |> Enum.with_index

    list = indexed_contents
    |> Enum.map(fn {x, index} -> check_num(index, contents, 0, run) end)
    |> Enum.filter(fn x -> x != :invalid end)
    |> List.first()

    Enum.min(list) + Enum.max(list)
  end

  def check_num(start_index, list, extra, target) do
    case list |> Enum.slice(start_index.. start_index+extra) |> Enum.sum() do
      x when x == target -> Enum.slice(list, start_index.. start_index+extra)
      x when x > target -> :invalid
      _ -> check_num(start_index, list, extra + 1, target)
    end
  end

  def calculate_valid_map(preamble) do
    preamble
    |> Enum.map(fn x ->
      preamble
      |> Enum.map(fn y -> x + y end)
    end)
    |> List.flatten()
  end
end
