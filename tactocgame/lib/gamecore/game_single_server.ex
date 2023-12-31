defmodule Gamecore.GameSingleServer do
  use GenServer

  def init(init_arg \\ %{}) do
    {:ok, init_arg}
  end

  # client api

  def parse_input(input) do
    GenServer.call(__MODULE__, {:parse_input, input})
  end

  def reset_game() do
    GenServer.call(__MODULE__, :reset_game)
  end

  def show_state() do
    GenServer.call(__MODULE__, :show_state)
  end

  # server handling

  def handle_call(:show_state, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:parse_input, input}, _from, state) do
    ret = update_internal_state(state, input)
    {:reply, ret, ret}
  end

  def handle_call(:reset_game, _from, _state) do
    {:reply, %{}, %{}}
  end

  defp update_internal_state(state, input) do
    if valid_turn(state, input) && valid_current_state(state) && valid_overlap(state, input) do
      pos_info = Map.get(input, "pos_info")
      role = Map.get(input, "role")
      Map.put(state, pos_info, role)
    else
      IO.inspect("invalid input")
      state
    end
  end

  defp valid_overlap(state, input) do
    pos_info = Map.get(input, :pos_info)
    Map.get(state, pos_info) == nil
  end

  defp valid_turn(state, input) do
    role = Map.get(input, "role")
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
    {is_finished, _} = validate_has_winner(state)
    IO.inspect(is_finished)
    map_size(state) < 9 and not is_finished
  end

  defp validate_has_winner(state) do
    if Map.get(state, {0, 0}) == 1 and Map.get(state, {0, 1}) == 1 and Map.get(state, {0, 2}) == 1 do
      {true, 1}
    else
      if Map.get(state, {1, 0}) == 1 and Map.get(state, {1, 1}) == 1 and
           Map.get(state, {1, 2}) == 1 do
        {true, 1}
      else
        if Map.get(state, {2, 0}) == 1 and Map.get(state, {2, 1}) == 1 and
             Map.get(state, {2, 2}) == 1 do
          {true, 1}
        else
          if Map.get(state, {0, 0}) == 1 and Map.get(state, {1, 0}) == 1 and
               Map.get(state, {2, 0}) == 1 do
            {true, 1}
          else
            if Map.get(state, {1, 0}) == 1 and Map.get(state, {1, 1}) == 1 and
                 Map.get(state, {1, 2}) == 1 do
              {true, 1}
            else
              if Map.get(state, {2, 0}) == 1 and Map.get(state, {2, 1}) == 1 and
                   Map.get(state, {2, 2}) == 1 do
                {true, 1}
              else
                if Map.get(state, {0, 0}) == 1 and Map.get(state, {1, 1}) == 1 and
                     Map.get(state, {2, 2}) == 1 do
                  {true, 1}
                else
                  if Map.get(state, {0, 2}) == 1 and Map.get(state, {1, 1}) == 1 and
                       Map.get(state, {2, 0}) == 1 do
                    {true, 1}
                  else
                    if Map.get(state, {0, 0}) == 2 and Map.get(state, {0, 1}) == 2 and
                         Map.get(state, {0, 2}) == 2 do
                      {true, 2}
                    else
                      if Map.get(state, {1, 0}) == 2 and Map.get(state, {1, 1}) == 2 and
                           Map.get(state, {1, 2}) == 2 do
                        {true, 2}
                      else
                        if Map.get(state, {2, 0}) == 2 and Map.get(state, {2, 1}) == 2 and
                             Map.get(state, {2, 2}) == 2 do
                          {true, 2}
                        else
                          if Map.get(state, {0, 0}) == 2 and Map.get(state, {1, 0}) == 2 and
                               Map.get(state, {2, 0}) == 2 do
                            {true, 2}
                          else
                            if Map.get(state, {1, 0}) == 2 and Map.get(state, {1, 1}) == 2 and
                                 Map.get(state, {1, 2}) == 2 do
                              {true, 2}
                            else
                              if Map.get(state, {2, 0}) == 2 and Map.get(state, {2, 1}) == 2 and
                                   Map.get(state, {2, 2}) == 2 do
                                {true, 2}
                              else
                                if Map.get(state, {0, 0}) == 2 and Map.get(state, {1, 1}) == 2 and
                                     Map.get(state, {2, 2}) == 2 do
                                  {true, 2}
                                else
                                  if Map.get(state, {0, 2}) == 2 and Map.get(state, {1, 1}) == 2 and
                                       Map.get(state, {2, 0}) == 2 do
                                    {true, 2}
                                  else
                                    {false, -1}
                                  end
                                end
                              end
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end

  # Gen behaviour

  def start_link(init_arg \\ %{}) do
    GenServer.start_link(__MODULE__, init_arg, name: __MODULE__)
  end
end
