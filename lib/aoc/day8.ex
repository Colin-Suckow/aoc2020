defmodule Day8 do
  def run() do
    code = Std.read_file_strings("input_files/day8.txt")
    result = machine_loop(MachineState.new(), code)
    case result do
      {:repeat, state} -> IO.inspect(state.executed_instructions, limit: :infinity)
      {:end, state} -> IO.inspect state
      {:err, msg} -> IO.puts msg
      _ -> IO.puts "Something went wrong"
    end
    result
  end

  def run2() do
    og_code = Std.read_file_strings("input_files/day8.txt")

    og_code
    |> Enum.with_index()
    |> Enum.map(fn {line, index} = x ->
      {opcode, operand} = parse_instruction(line)
      case opcode do
        :jmp -> og_code |> List.replace_at(index, instruction_to_string(:nop, operand))
        :nop -> og_code |> List.replace_at(index, instruction_to_string(:jmp, operand))
        _ -> :same
      end
    end)
    |> Enum.filter(fn code -> code != :same end)
    |> Enum.map(fn code -> machine_loop(MachineState.new(), code) end)
    |> Enum.filter(fn result -> result |> elem(0) == :end end)
  end

  def machine_loop(state, code) do
    cond do
      state.pc >= length(code) -> {:end, state}
      MachineState.repeat?(state) -> {:repeat, state}
      true ->
        state = MachineState.record_instruction(state)
        {opcode, operand} = parse_instruction(code |> Enum.at(state.pc))
        case execute(state, opcode, operand) do
          {:ok, new_state} -> machine_loop(new_state, code)
          {_, msg} -> {:err, msg}
        end
    end
  end

  def execute(state, opcode, operand) do
    if opcode == :err do
      {:err, "Bad opcode"}
    else
      new_state = case opcode do
        :acc ->
          MachineState.add_acc(state, operand)
          |> MachineState.increment_pc
        :jmp -> MachineState.jmp_pc(state, operand)
        :nop -> MachineState.increment_pc(state)
      end
      {:ok, new_state}
    end
  end

  def execute(:err, msg) do
    {:err, msg}
  end

  def parse_instruction(line) do
    parts = line
    |> String.split(" ", trim: true)

    opcode = case parts |> hd do
      "acc" -> :acc
      "jmp" -> :jmp
      "nop" -> :nop
      _ -> {:err, "Unknown instruction"}
    end

    {operand, _} = parts
    |> Enum.at(1)
    |> Integer.parse


    {opcode, operand}
  end

  def instruction_to_string(opcode, operand) do
    s_opcode = case opcode do
      :acc -> "acc"
      :jmp -> "jmp"
      :nop -> "nop"
      _ -> "error"
    end
    s_opcode <> " " <> Integer.to_string(operand)
  end

end

defmodule MachineState do
  defstruct acc: 0, pc: 0, executed_instructions: [], last_pc: 0

  def new(), do:  %MachineState{}
  def increment_pc(state), do: %MachineState{state | last_pc: state.pc, pc: state.pc + 1}

  def jmp_pc(state, address), do: %MachineState{state | last_pc: state.pc, pc: state.pc + address}

  def add_acc(state, operand), do: %MachineState{state | acc: state.acc + operand}

  def record_instruction(state), do: %MachineState{state | executed_instructions: state.executed_instructions ++ [state.pc]}

  def repeat?(state), do: Enum.uniq(state.executed_instructions) != state.executed_instructions
end
