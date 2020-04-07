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
end
