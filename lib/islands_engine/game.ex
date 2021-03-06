defmodule IslandsEngine.Game do
  use GenServer
  alias IslandsEngine.{Board, Coordinate, Guesses, Island, Rules }

  @players [:player1, :player2]

  def init(name), do:
    {:ok, %{
      player1: %{name: name, board: Board.new(), guesses: Guesses.new()},
      player2: %{name: nil, board: Board.new(), guesses: Guesses.new()},
      rules: %Rules{}
    }}

  defp update_player2_name(state_data, name), do:
    put_in(state_data.player2.name, name)

  defp update_rules(state_data, rules), do:
    %{ state_data | rules: rules }

  defp reply_success(state_data, reply), do:
    {:reply, reply, state_data}

  def handle_call({:add_player, name}, _from, state_data) do # synchronous
    with {:ok, rules} <- Rules.check(state_data.rules, :add_player)
    do
      state_data
      |> update_player2_name(name)
      |> update_rules(rules)
      |> reply_success(:ok)
    else
      :error -> {:reply, :error, :state_data}
    end
  end

  # game interface:
  
  def add_player(game, name) when is_binary(name), do:
    GenServer.call(game, {:add_player, name})

  def start_link(name) when is_binary(name), do:
    GenServer.start_link(__MODULE__, name, [])
end