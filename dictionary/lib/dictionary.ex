defmodule Dictionary do
  alias Dictionary.Runtime.Server
  defdelegate random_word(), to: Server
end
