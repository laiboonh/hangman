defmodule B2Web.Live.Game do
  use B2Web, :live_view
  def mount(_params, _session, socket) do
    game = Hangman.new_game()
    tally = Hangman.tally(game)
    socket = assign(socket, %{game: game, tally: tally})
    {:ok, socket}
  end

  @impl
  def handle_event("make_move", %{"key" => key}, socket) do
    game = socket.assigns.game
    tally = Hangman.make_move(game, key)
    {:noreply, assign(socket, :tally, tally)}
  end

  def render(assigns) do
    ~L"""
    <div class="game-holder", phx-window-keyup="make_move">
    <%= live_component(__MODULE__.Figure, tally: @tally, id: 1) %>
    <%= live_component(__MODULE__.Alphabet, tally: @tally, id: 2) %>
    <%= live_component(__MODULE__.WordSoFar, tally: @tally, id: 3) %>
    """
  end
end