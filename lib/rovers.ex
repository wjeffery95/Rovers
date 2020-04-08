defmodule Rovers do
  use Application

  @impl true
  def start(_type, _args) do
    Rovers.Supervisor.start_link(name: Rovers.Supervisor)
  end
end
