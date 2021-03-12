defmodule IslandsEngine.RulesTest do
  use ExUnit.Case
  alias IslandsEngine.Rules

  describe "check wins" do
    test "no win player1" do
      rules = %Rules{state: :player1_turn}
      assert Rules.check(rules, {:win_check, :no_win}) === {:ok, rules}
    end

    test "win player1" do
      {:ok, rules} = Rules.check(%Rules{state: :player1_turn}, {:win_check, :win})
      assert rules.state === :game_over
    end

    test "no win player2" do
      rules = %Rules{state: :player2_turn}
      assert Rules.check(rules, {:win_check, :no_win}) === {:ok, rules}
    end

    test "win player2" do
      {:ok, rules} = Rules.check(%Rules{state: :player2_turn}, {:win_check, :win})
      assert rules.state === :game_over
    end
  end

  describe "switch turn on coordinate guess" do
    test "switch to player2 when player1 guess" do
      {:ok, rules} = Rules.check(%Rules{state: :player1_turn}, {:guess_coordinate, :player1})
      assert rules.state === :player2_turn
    end

    test "switch to player1 when player2 guess" do
      {:ok, rules} = Rules.check(%Rules{state: :player2_turn}, {:guess_coordinate, :player2})
      assert rules.state === :player1_turn
    end
  end

  test "no match" do
    assert Rules.check(%Rules{state: :game_over}, {:win_check, :win}) === :error
    assert Rules.check(%Rules{state: :player1_turn}, {:other, :win}) === :error
    assert Rules.check(%Rules{state: :player2_turn}, {:win_check, :other}) === :error
  end
end
