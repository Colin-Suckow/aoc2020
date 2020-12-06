defmodule Day6 do
  def run do
    elem(File.read("input_files/day6.txt"), 1)
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn(line) -> line |> String.graphemes |> Enum.filter(fn(c) -> c != "\n" end) end)
    |> Enum.map(fn(line) -> line |> Enum.uniq |> length end)
    |> Enum.sum()
  end

  def run2 do
    elem(File.read("input_files/day6.txt"), 1)
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn(line) -> line |> String.split("\n", trim: true) end)
    |> Enum.map(fn(group) ->
      letters = for n <- ?a..?z, do: << n :: utf8 >>
      letters
      |> Enum.map(fn(letter) -> all_yes(letter, group) end)
      |> Enum.filter(fn(x) -> x == true end)
      |> length
    end)
  |> Enum.sum
  end


  def all_yes(char, [] = group) do
    false
  end

  def all_yes(char, group) do
    group
    |> Enum.all?(fn(p) -> p |> String.graphemes |> Enum.member?(char) end)
  end
end
