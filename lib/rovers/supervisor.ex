defmodule Rovers.Supervisor do
  use Supervisor

  def start_link(_init_arg) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def init(:ok) do
    children = [
      {Rovers.World, name: Rovers.World}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
