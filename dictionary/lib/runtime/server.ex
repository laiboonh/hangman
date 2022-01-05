defmodule Dictionary.Runtime.Server do
  alias Dictionary.WordList

  @me __MODULE__

  use Agent

  def start_link(_arg) do
    Agent.start_link(fn -> WordList.start end, name: @me)
  end

  def random_word() do
    Agent.get(@me, fn words -> WordList.random_word(words) end)
  end
end
