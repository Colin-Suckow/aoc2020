defmodule Day12 do
  def run do
    contents = Std.read_file_strings("input_files/day12.txt")
    state = %{:direction => :east, x: 0, y: 0}

    final_state = contents
    |> move(state)

    manhatten_distance(final_state.x, final_state.y)
  end

  def run2 do
    contents = Std.read_file_strings("input_files/day12.txt")

    final_state = %{direction: :east, ship_x: 0, ship_y: 0, wp_rel_x: 10, wp_rel_y: 1}
    |> move2(contents)

    manhatten_distance(final_state.ship_x, final_state.ship_y)
  end

  def move2(state, []), do: state

  def move2(state, moves) do
    move = moves |> hd

    [direction, magnitude] = String.split(move, ~r{}, parts: 2, trim: true)
    magnitude = String.to_integer(magnitude)

    case direction do
      "N" -> translate_wp(:north, magnitude, state)
      "S" -> translate_wp(:south, magnitude, state)
      "E" -> translate_wp(:east, magnitude, state)
      "W" -> translate_wp(:west, magnitude, state)

      "F" -> warp_ship(magnitude, state)

      "L" -> rotate_wp(:left, magnitude, state)
      "R" -> rotate_wp(:right, magnitude, state)
    end
    |> move2(moves |> tl)
  end

  def warp_ship(times, state) do
    %{state | ship_x: state.ship_x + state.wp_rel_x * times, ship_y: state.ship_y + state.wp_rel_y * times}
  end

  def translate_wp(direction, distance, state) do
    case direction do
      :north -> %{state | wp_rel_y: state.wp_rel_y + distance}
      :south -> %{state | wp_rel_y: state.wp_rel_y - distance}
      :east -> %{state | wp_rel_x: state.wp_rel_x + distance}
      :west -> %{state | wp_rel_x: state.wp_rel_x - distance}
    end
  end

  def rotate_wp(_direction, 0, state), do: state

  def rotate_wp(direction, angle, state) do
    new_state = case direction do
      :right -> %{state | wp_rel_x: state.wp_rel_y, wp_rel_y: -state.wp_rel_x}
      :left -> %{state | wp_rel_x: -state.wp_rel_y, wp_rel_y: state.wp_rel_x}
    end
    rotate_wp(direction, angle - 90, new_state)
  end


  def move([], state), do: state

  def move(moves, state) do
    move = moves
    |> hd

    [direction, distance] = String.split(move, ~r{}, parts: 2, trim: true)
    distance = String.to_integer(distance)

    decoded_direction =
      case direction do
        "N" -> :north
        "S" -> :south
        "E" -> :east
        "W" -> :west
        "F" -> state.direction

        "L" -> left(state.direction, distance)
        "R" -> right(state.direction, distance)
      end


    if direction == "L" || direction == "R" do
      move(moves |> tl, %{:direction => decoded_direction, x: state.x, y: state.y})
    else
      {new_x, new_y} = case decoded_direction do
        :north -> {state.x, state.y + distance}
        :south -> {state.x, state.y - distance}
        :east -> {state.x + distance, state.y}
        :west -> {state.x - distance, state.y}
      end
      move(moves |> tl, %{:direction => state.direction, x: new_x, y: new_y})
    end
  end

  def right(direction, 0), do: direction

  def right(direction, angle) do
    case direction do
      :north -> :east
      :east -> :south
      :south -> :west
      :west -> :north
    end
    |> right(angle - 90)
  end

  def left(direction, 0), do: direction

  def left(direction, angle) do
    case direction do
      :north -> :west
      :west -> :south
      :south -> :east
      :east -> :north
    end
    |> left(angle - 90)
  end

  def manhatten_distance(x, y), do: abs(x) + abs(y)
end
