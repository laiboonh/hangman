defmodule Dictionary.Runtime.Application do
  use Application
  def start(_type, _args) do
    children = [
      {Dictionary.Runtime.Server, []}
    ]
    option = [
      name: Dictionary.Runtime.Supervisor,
      strategy: :one_for_one
    ]
    Supervisor.start_link(children, option)
  end
end