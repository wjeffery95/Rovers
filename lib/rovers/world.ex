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

  @spec start_link(any) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @spec lookup_rover(pid(), String.t()) :: {:ok, Rover.t()} | {:error, :noRover}
  def lookup_rover(world, name) do
    GenServer.call(world, {:lookup, name})
  end

  @spec create_rover(pid(), String.t(), Position.t()) :: {:ok, nil} | {:error, :offGrid}
  def create_rover(world, name, position) do
    GenServer.call(world, {:create, {name, position}})
  end

  @spec move_rover(pid(), String.t(), Position.instruction()) ::
          {:ok, nil | :offGrid} | {:error, :noRover}
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
    case Map.fetch(world.rovers, name) do
      :error -> {:reply, {:error, :noRover}, world}
      roverStatus -> {:reply, roverStatus, world}
    end
  end

  @impl true
  def handle_call({:create, {name, position}}, _from, world) do
    case Grid.onGrid?(world.grid, position.vector) do
      false ->
        {:reply, {:error, :offGrid}, world}

      true ->
        rovers = Map.put(world.rovers, name, %Rover{position: position, status: :ok})
        {:reply, {:ok, nil}, %__MODULE__{grid: world.grid, rovers: rovers}}
    end
  end

  @impl true
  def handle_call({:move, {name, instruction}}, _from, world) do
    if Map.has_key?(world.rovers, name) do
      {:reply, {:error, :noRover}, world}
    end

    {rover, rovers} =
      Map.get_and_update!(
        world.rovers,
        name,
        fn rover ->
          rover = Rover.move(rover, instruction, world.grid)
          {rover, rover}
        end
      )

    world = %__MODULE__{grid: world.grid, rovers: rovers}

    case rover.status do
      :ok -> {:reply, {:ok, nil}, world}
      :offGrid -> {:reply, {:ok, :offGrid}, world}
    end
  end
end
