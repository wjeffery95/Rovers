defmodule Rovers.Model.Rover do
  alias Rovers.Model.Position, as: Position
  alias Rovers.Model.Grid, as: Grid

  @type status :: :ok | :offGrid

  @type t :: %__MODULE__{
          position: Position.t(),
          status: Grid.status()
        }

  @enforce_keys [:position, :status]
  defstruct [:position, :status]

  @doc """

  ### Example

      iex> Rover.move(
      ...>   %Rover{
      ...>     position: %Position{direction: :north, vector: %Vector{x: 1, y: 1}},
      ...>     status: :ok
      ...>   },
      ...>   :forward,
      ...>   %Grid{height: 3, width: 3}
      ...> )
      %Rover{
        position: %Position{direction: :north, vector: %Vector{x: 1, y: 2}},
        status: :ok
      }

  """
  @spec move(__MODULE__.t(), Position.instruction(), Grid.t()) :: __MODULE__.t()
  def move(%{status: status, position: position}, instruction, grid) do
    if status == :offGrid do
      %__MODULE__{status: :offGrid, position: position}
    end

    newPosition = Position.executeInstruction(position, instruction)

    case Grid.onGrid?(grid, newPosition.vector) do
      true -> %__MODULE__{status: :ok, position: newPosition}
      false -> %__MODULE__{status: :offGrid, position: position}
    end
  end

  @doc """

  ### Examples

      iex> Rover.multiMove(
      ...>   %Rover{
      ...>     position: %Position{direction: :north, vector: %Vector{x: 2, y: 2}},
      ...>     status: :ok,
      ...>   },
      ...>   [:left, :forward, :right, :forward],
      ...>   %Grid{width: 5, height: 5}
      ...> )
      %Rover{
        position: %Position{direction: :north, vector: %Vector{x: 1, y: 3}},
        status: :ok,
      }

      iex> Rover.multiMove(
      ...>   %Rover{
      ...>     position: %Position{direction: :east, vector: %Vector{x: 7, y: 4}},
      ...>     status: :ok,
      ...>   },
      ...>   [:forward, :forward, :right, :forward],
      ...>   %Grid{width: 9, height: 6}
      ...> )
      %Rover{
        position: %Position{direction: :east, vector: %Vector{x: 8, y: 4}},
        status: :offGrid,
      }

      iex> Rover.multiMove(
      ...>   %Rover{
      ...>     position: %Position{direction: :west, vector: %Vector{x: 4, y: 4}},
      ...>     status: :ok,
      ...>   },
      ...>   [:forward, :forward, :right, :forward, :forward, :left, :forward, :right],
      ...>   %Grid{width: 6, height: 9}
      ...> )
      %Rover{
        position: %Position{direction: :north, vector: %Vector{x: 1, y: 6}},
        status: :ok,
      }

  """
  @spec multiMove(__MODULE__.t(), [Position.instructions()], Grid.t()) :: __MODULE__.t()
  def multiMove(rover, instructions, grid) do
    case instructions do
      [] ->
        rover

      [instruction | instructions] ->
        rover = move(rover, instruction, grid)

        case rover.status do
          :offGrid -> rover
          :ok -> multiMove(rover, instructions, grid)
        end
    end
  end
end
