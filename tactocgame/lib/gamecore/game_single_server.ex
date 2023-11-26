defmodule Gamecore.GameSingleServer do
  use GenServer

  def init(init_arg \\ %{}) do
    {:ok, init_arg}
  end

  def parse_input(input) do
    GenServer.call(__MODULE__, {:parse_input, input})
  end

  def handle_call({:parse_input, input}, _from, state) do
    ret = update_internal_state(state, input)
    {:reply, ret, ret}
  end

  defp update_internal_state(state, input) do
    if valid_turn(state, input) && valid_current_state(state) && valid_overlap(state, input) do
      pos_info = Map.get(input, :pos_info)
      role = Map.get(input, :role)
      Map.put(state, pos_info, role)
    else
      state
    end
  end

  defp valid_overlap(state, input) do
    pos_info = Map.get(input, :pos_info)
    Map.get(state, pos_info) == nil
  end

  defp valid_turn(state, input) do
    role = Map.get(input, :role)

    if role == 1 do
      if rem(map_size(state), 2) == 1 do
        false
      else
        true
      end
    else
      if rem(map_size(state), 2) == 0 do
        false
      else
        true
      end
    end
  end

  defp valid_current_state(state) do
    # check condition add later
    map_size(state) < 9
  end

  def start_link(init_arg \\ %{}) do
    GenServer.start_link(__MODULE__, init_arg, name: __MODULE__)
  end
end
