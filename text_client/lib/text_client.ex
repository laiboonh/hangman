defmodule TextClient do
  alias TextClient.Impl.Player
  alias TextClient.Runtime.RemoteHangman
  def start() do
    RemoteHangman.connect()
    |> Player.start()
  end
end
