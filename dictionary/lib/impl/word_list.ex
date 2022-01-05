defmodule Dictionary.WordList do
  def start() do
    "../../assets/words.txt"
    |> Path.expand(__DIR__)
    |> File.read!()
    |> String.split(~r/\n/, trim: true)
  end

  def random_word(words) do
    Enum.random(words)
  end
end