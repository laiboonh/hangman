defmodule TextClient.Runtime.RemoteHangman do
  @remote_server :"hangman@Lais-Mac-mini"
  def connect() do
    :rpc.call(@remote_server, Hangman, :new_game, [])
  end
end