defmodule Rovers.Model.Position do
  alias Rovers.Model.Vector, as: Vector

  @type instruction :: :forward | :left | :right
  @type direction :: :north | :east | :south | :west

  @type t :: %__MODULE__{
          direction: __MODULE__.direction(),
          vector: Rovers.Model.Vector.t()
        }

  @enforce_keys [:direction, :vector]
  defstruct [:direction, :vector]

  @doc """

  ### Example

      iex> Position.executeInstruction(
      ...>   %Position{direction: :north, vector: %Vector{x: 1, y: 1}},
      ...>   :forward
      ...> )
      %Position{direction: :north, vector: %Vector{x: 1, y: 2}}

      iex> Position.executeInstruction(
      ...>   %Position{direction: :west, vector: %Vector{x: 0, y: -2}},
      ...>   :forward
      ...> )
      %Position{direction: :west, vector: %Vector{x: -1 , y: -2}}

      iex> Position.executeInstruction(
      ...>   %Position{direction: :north, vector: %Vector{x: 1, y: 1}},
      ...>   :left
      ...> )
      %Position{direction: :west, vector: %Vector{x: 1, y: 1}}


      iex> Position.executeInstruction(
      ...>   %Position{direction: :east, vector: %Vector{x: 1, y: 1}},
      ...>   :right
      ...> )
      %Position{direction: :south, vector: %Vector{x: 1, y: 1}}

  """
  @spec executeInstruction(__MODULE__.t(), __MODULE__.instruction()) :: __MODULE__.t()
  def executeInstruction(%{direction: direction, vector: vector}, :forward) do
    changes = %{
      north: %Vector{x: 0, y: 1},
      east: %Vector{x: 1, y: 0},
      south: %Vector{x: 0, y: -1},
      west: %Vector{x: -1, y: 0}
    }

    change = Map.get(changes, direction)
    %__MODULE__{direction: direction, vector: Vector.add(vector, change)}
  end

  def executeInstruction(%{direction: direction, vector: vector}, rotation) do
    directionNumbers = %{north: 0, east: 1, south: 2, west: 3}

    rotationNumber = Map.get(%{left: -1, right: 1}, rotation)
    directionNumber = Map.get(directionNumbers, direction)
    newDirectionNumber = rem(directionNumber + rotationNumber + 4, 4)

    newDirection =
      directionNumbers |> Enum.find(fn {_key, val} -> val == newDirectionNumber end) |> elem(0)

    %__MODULE__{direction: newDirection, vector: vector}
  end

  @spec create(__MODULE__.direction(), integer, integer) :: __MODULE__.t()
  def create(direction, x, y) do
    %__MODULE__{direction: direction, vector: %Vector{x: x, y: y}}
  end
end
