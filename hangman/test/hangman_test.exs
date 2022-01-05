defmodule HangmanTest do
  use ExUnit.Case
  doctest Hangman

  alias Hangman.Impl.Game

  test "new_game returns struct" do
    game = Game.new_game("wombat")
    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert game.letters == ["w", "o", "m", "b", "a", "t"]
  end

  test "state does not change if make move for game won or lost" do
    for state <- [:won, :lost] do
      game = Game.new_game("wombat")
      game = Map.put(game, :game_state, state)
      {new_game, _tally} = Game.make_move(game, "x")
      assert game == new_game
    end
  end

  test "duplicate guess for make move" do
    game = Game.new_game("wombat")
    {game, _tally} = Game.make_move(game, "x")
    assert game.game_state != :already_used
    {game, _tally} = Game.make_move(game, "x")
    assert game.game_state == :already_used
  end

  test "guesses recorded for make move" do
    game = Game.new_game("wombat")
    {game, _tally} = Game.make_move(game, "x")
    {game, _tally} = Game.make_move(game, "y")
    assert game.used == MapSet.new(["x", "y"])
  end

  test "good guess recorded for make move" do
    game = Game.new_game("wombat")
    {game, _tally} = Game.make_move(game, "w")
    assert game.game_state == :good_guess
  end

  test "bad guess recorded for make move" do
    game = Game.new_game("wombat")
    {game, _tally} = Game.make_move(game, "x")
    assert game.used == MapSet.new(["x"])
    assert game.turns_left == 6
    assert game.game_state == :bad_guess
  end

  test "correct guesses win game" do
    [
      ["h", :good_guess, 7, ["h", "_", "_", "_", "_"], ["h"]],
      ["x", :bad_guess, 6, ["h", "_", "_", "_", "_"], ["h", "x"]],
      ["x", :already_used, 6, ["h", "_", "_", "_", "_"], ["h", "x"]],
      ["e", :good_guess, 6, ["h", "e", "_", "_", "_"], ["e", "h", "x"]],
      ["l", :good_guess, 6, ["h", "e", "l", "l", "_"], ["e", "h", "l", "x"]],
      ["o", :won, 6, ["h", "e", "l", "l", "o"], ["e", "h", "l", "o", "x"]],
    ]
    |> test_sequence_of_moves
  end

  test "wrong guesses lose game" do
    [
      ["h", :good_guess, 7, ["h", "_", "_", "_", "_"], ["h"]],
      ["x", :bad_guess, 6, ["h", "_", "_", "_", "_"], ["h", "x"]],
      ["y", :bad_guess, 5, ["h", "_", "_", "_", "_"], ["h", "x", "y"]],
      ["z", :bad_guess, 4, ["h", "_", "_", "_", "_"], ["h", "x", "y", "z"]],
      ["a", :bad_guess, 3, ["h", "_", "_", "_", "_"], ["a", "h", "x", "y", "z"]],
      ["b", :bad_guess, 2, ["h", "_", "_", "_", "_"], ["a", "b", "h", "x", "y", "z"]],
      ["c", :bad_guess, 1, ["h", "_", "_", "_", "_"], ["a", "b", "c", "h", "x", "y", "z"]],
      ["d", :lost, 0, ["h", "e", "l", "l", "o"], ["a", "b", "c", "d", "h", "x", "y", "z"]],
    ]
    |> test_sequence_of_moves
  end

  defp test_sequence_of_moves(script) do
    game = Game.new_game("hello")
    Enum.reduce(script, game, &check_one_move/2)
  end

  defp check_one_move([guess, state, turns, letters, used], game) do
    {game, tally} = Game.make_move(game, guess)
    assert tally.game_state == state
    assert tally.turns_left == turns
    assert tally.letters == letters
    assert tally.used == used
    game
  end

end
