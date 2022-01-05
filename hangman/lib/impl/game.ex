defmodule Hangman.Impl.Game do
  alias Hangman.Type
  @type t :: %__MODULE__{
               turns_left: integer,
               game_state: Type.state,
               letters: list(String.t),
               used: MapSet.t(String.t)
             }

  defstruct(
    turns_left: 7,
    game_state: :initializing,
    letters: [],
    used: MapSet.new()
  )

  @spec new_game :: t
  def new_game do
    Dictionary.random_word
    |> new_game
  end

  @spec new_game(String.t) :: t
  def new_game(word) do
    %Hangman.Impl.Game{
      letters: word
               |> String.codepoints

    }
  end

  @spec make_move(t, String.t) :: {t, Type.tally}
  def make_move(game = %__MODULE__{game_state: state}, _move) when state in [:won, :lost] do
    return_with_tally(game)
  end

  def make_move(game, guess) do
    accept_move(game, guess, MapSet.member?(game.used, guess))
    |> return_with_tally
  end


  def accept_move(game, _guess, _already_used = true) do
    %{game | game_state: :already_used}
  end

  def accept_move(game, guess, _already_used) do
    %{game | used: MapSet.put(game.used, guess)}
    |> score_guess(MapSet.member?(MapSet.new(game.letters), guess))
  end

  def score_guess(game, _good_guess = true) do
    new_state = maybe_won(MapSet.subset?(MapSet.new(game.letters), game.used))
    %{game | game_state: new_state}
  end
  def score_guess(game = %{turns_left: 1}, _good_guess) do
    %{game | game_state: :lost, turns_left: 0}
  end
  def score_guess(game, _good_guess) do
    %{game | game_state: :bad_guess, turns_left: game.turns_left - 1}
  end

  defp maybe_won(true), do: :won
  defp maybe_won(_), do: :good_guess

  defp return_with_tally(game) do
    {game, tally(game)}
  end

  def tally(game) do
    %{
      turns_left: game.turns_left,
      game_state: game.game_state,
      letters: reveal_letters(game),
      used: game.used
            |> MapSet.to_list
            |> Enum.sort,
    }
  end

  defp reveal_letters(game = %{game_state: :lost}) do
    game.letters
  end
  defp reveal_letters(game) do
    Enum.map(game.letters, fn x -> if MapSet.member?(game.used, x), do: x, else: "_" end)
  end
end