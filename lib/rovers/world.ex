defmodule Rovers.World do
  use GenServer

  alias Rovers.Model.Grid, as: Grid
  alias Rovers.Model.Position, as: Position
  alias Rovers.Model.Rover, as: Rover

  @type t :: %__MODULE__{
          grid: Grid.t(),
          rovers: %{String.t() => Rovers.t()}
        }

  @enforce_keys [:grid, :rovers]
  defstruct [:grid, :rovers]

  @spec start_link(Map.t()) :: pid()
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  @spec lookup_rover(pid(), String.t()) :: Rover.t()
  def lookup_rover(world, name) do
    GenServer.call(world, {:lookup, name})
  end

  @spec create_rover(pid(), String.t(), Position.t()) :: Rover.t()
  def create_rover(world, name, position) do
    GenServer.call(world, {:create, {name, position}})
  end

  @spec move_rover(pid(), String.t(), Position.instruction()) :: :ok | :noRover
  def move_rover(world, name, instruction) do
    GenServer.call(world, {:move, {name, instruction}})
  end

  @impl true
  def init(_) do
    defaultGrid = %Grid{height: 10, width: 10}
    {:ok, %__MODULE__{grid: defaultGrid, rovers: %{}}}
  end

  @impl true
  def handle_call({:lookup, name}, _from, world) do
    {:reply, Map.fetch(world.rovers, name), world}
  end

  @impl true
  def handle_call({:create, {name, position}}, _from, world) do
    case Grid.onGrid?(world.grid, position.vector) do
      false ->
        {:reply, :offGrid, world}

      true ->
        rover = %Rover{position: position, status: :ok}
        rovers = Map.put(world.rovers, name, rover)
        {:reply, :ok, %__MODULE__{grid: world.grid, rovers: rovers}}
    end
  end

  @impl true
  def handle_call({:move, {name, instruction}}, _from, %{grid: grid, rovers: rovers}) do
    case Map.pop(rovers, name) do
      {nil, _} ->
        {:reply, :noRover, %__MODULE__{grid: grid, rovers: rovers}}

      {rover, rovers} ->
        rover = Rover.move(rover, instruction, grid)
        world = %__MODULE__{grid: grid, rovers: Map.put(rovers, name, rover)}
        {:reply, rover.status, world}
    end
  end
end
