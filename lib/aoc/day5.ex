defmodule Day5 do
  def run do
    lines = Std.read_file_strings("input_files/day5.txt")
    rows = Enum.map(lines, fn(x) -> calculate_row(x |> String.graphemes, Enum.to_list(0..128)) end)
    cols = Enum.map(lines, fn(x) -> calculate_col(x |> String.graphemes |> Enum.filter(fn(c) -> c == "L" || c == "R" end), Enum.to_list(0..8)) end)
    seats = for {c, r} <- Enum.zip(cols, rows), do: (r * 8) + c
    max = seats |> Enum.max
    min = seats |> Enum.min
    Enum.filter(min..max, fn(x) -> x not in seats end)
  end

  def calculate_row(val, rows) do
    if length(rows) <= 1 do
      rows |> Enum.at(0)
    else
      case val |> hd do
        "F" -> calculate_row(val |> tl, Enum.split(rows, div(length(rows), 2)) |> elem(0))
        "B" -> calculate_row(val |> tl, Enum.split(rows, div(length(rows), 2)) |> elem(1))
        _ -> [0]
      end
    end
  end

  def calculate_col(val, cols) do
    if length(val) <= 0 || length(cols) <= 1 do
      cols |> Enum.at(0)
    else
      case val |> hd do
        "L" -> calculate_col(val |> tl, Enum.split(cols, div(length(cols), 2)) |> elem(0))
        "R" -> calculate_col(val |> tl, Enum.split(cols, div(length(cols), 2)) |> elem(1))
        _ -> [0]
      end
    end
  end
end
