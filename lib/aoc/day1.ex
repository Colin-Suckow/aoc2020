defmodule Day1 do
  def run do
    contents = Std.read_file_ints("input_files/day1.txt")
    List.first for x <- contents, y <- contents, z <- contents, x + y + z == 2020, do: x * y * z
  end
end
