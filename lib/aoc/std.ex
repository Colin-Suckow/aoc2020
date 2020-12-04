defmodule Std do
  def read_file_strings(path) do
    elem(File.read(path), 1)
    |> String.split("\n", trim: true)
  end

  def read_file_ints(path) do
    elem(File.read(path), 1)
    |> String.split("\n", trim: true)
    |> Enum.map(&elem(Integer.parse(&1), 0))
  end
end
