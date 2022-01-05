defmodule TextClient.Impl.Player do
  def start(game) do
    tally = Hangman.tally(game)
    interact({game, tally})
  end

  def interact({_game, _tally = %{game_state: :won}}) do
    IO.puts("Game won!")
  end
  def interact({_game, tally = %{game_state: :lost, letters: letters}}) do
    IO.puts("Game lost. #{Enum.join(letters)}")
  end
  def interact({game, tally}) do
    IO.puts(feedback_for(tally))
    IO.puts(summary(tally))
    tally = Hangman.make_move(game, get_guess())
    interact({game, tally})
  end

  def feedback_for(tally = %{game_state: :initializing, used: used, letters: letters, turns_left: turns_left}) do
    "Make a guess."
  end
  def feedback_for(tally = %{game_state: :good_guess, used: used, letters: letters, turns_left: turns_left}) do
    "Good guess."
  end
  def feedback_for(tally = %{game_state: :bad_guess, used: used, letters: letters, turns_left: turns_left}) do
    "Bad guess."
  end
  def feedback_for(tally = %{game_state: :already_used, used: used, letters: letters, turns_left: turns_left}) do
    "Guess already used."
  end

  def get_guess() do
    IO.gets("Next guess: ")
    |> String.trim()
    |> String.downcase()
  end

  def summary(tally = %{used: used, letters: letters, turns_left: turns_left}) do
    "So far:#{inspect(letters)}, Guessed:#{inspect(used)}, Turns Left: #{turns_left}"
  end


end