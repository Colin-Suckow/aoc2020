# defmodule Day4 do
#   def run do
#     contents = elem(File.read("input_files/day4.txt"), 1)
#     |> String.split("\n\n", trim: true)
#     |> Enum.map(&String.replace(&1, "\n", " "))
#     |> Enum.filter(&validate(&1))
#     |> length
#   end

#   def validate(line) do
#     values_valid = line
#     |> String.split(" ", trime: true)
#     |> Enum.map(fn(v) ->
#       vs = String.split(v, ":", trim: true)
#       first = Enum.at(vs, 0)
#       last = Enum.at(vs, 1)
#       case first do
#         "byr" -> last |> Integer.parse(10) |> elem(0) |> check_year(1920, 2002)
#         "iyr" -> last |> Integer.parse(10) |> elem(0) |> check_year(2010, 2020)
#         "eyr" -> last |> Integer.parse(10) |> elem(0) |> check_year(2020, 2030)
#         "hgt" -> check_height(last)
#         "hcl" -> check_hair_color(last)
#         "ecl" -> check_eye_color(last)
#         "pid" -> check_id(last)
#         _ -> true
#       end
#     end)
#     |> Enum.member?(false) == false

#     values_valid and String.contains?(line, "byr") and String.contains?(line, "iyr") and String.contains?(line, "eyr") and String.contains?(line, "hgt") and String.contains?(line, "hcl") and String.contains?(line, "ecl") and String.contains?(line, "pid")
#   end

#   def check_year(num, low, high) do
#     num >= low and num <= high
#   end

#   def check_height(val) do
#     if Regex.match?(~r/[a-z]+/, val) do
#       h_range = case Regex.scan(~r/[a-z]+/, val) |> Enum.at(0) |> Enum.at(0) do
#         "cm" -> 150..193
#         "in" -> 59..76
#         _ -> 0..0
#       end
#       h = Regex.scan(~r/[0-9]+/, val)
#       |> Enum.at(0)
#       |> Enum.at(0)
#       |> Integer.parse(10)
#       |> elem(0)
#       Enum.member?(h_range, h)
#     else
#       false
#     end
#   end

#   def check_hair_color(val) do
#     Regex.match?(~r/#[0-9a-f]{6}/, val) and val |> String.graphemes() |> length() < 8
#   end

#   def check_eye_color(val) do
#     case val do
#       "amb" -> true
#       "blu" -> true
#       "brn" -> true
#       "gry" -> true
#       "grn" -> true
#       "hzl" -> true
#       "oth" -> true
#       _ -> false
#     end
#   end

#   def check_id(val) do
#     is_num = case Integer.parse(val) do
#       {_, _} -> true
#       _ -> false
#     end
#     is_num and val |> String.graphemes() |> length == 9
#   end
# end
