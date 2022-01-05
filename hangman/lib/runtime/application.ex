defmodule Hangman.Runtime.Application do
  use Application
  @sup_name GameStarter
  def start(_type, _args) do
    supervisor = [
      {DynamicSupervisor, strategy: :one_for_one, name: @sup_name}
    ]
    Supervisor.start_link(supervisor, strategy: :one_for_one)
  end

  def start_game() do
    DynamicSupervisor.start_child(@sup_name, {Hangman.Runtime.Server, []})
  end
end