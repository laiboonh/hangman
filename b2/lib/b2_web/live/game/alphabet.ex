defmodule B2Web.Live.Game.Alphabet do
  use B2Web, :live_component

  def mount(socket) do
    letters = ?a..?z
              |> Enum.map(&<<&1 :: utf8>>)
    {:ok, assign(socket, :letters, letters)}
  end

  def render(assigns) do
    ~H"""
    <div class="alphabet">
      <%= for letter <- @letters do %>
        <% cls = classOf(@tally, letter) %>
        <div phx-click="make_move" phx-value-key={letter} class={cls}>
          <%= letter %>
        </div>
      <% end %>
    </div>
    """
  end

  def classOf(tally, letter) do
    cond do
      Enum.member?(tally.letters, letter) -> "one-letter correct"
      Enum.member?(tally.used, letter) -> "one-letter wrong"
      true -> "one-letter"
    end
  end
end