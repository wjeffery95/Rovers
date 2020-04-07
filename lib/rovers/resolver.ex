defmodule Rovers.Resolver do
  alias Rovers.Model.Grid, as: Grid
  alias Rovers.Model.Position, as: Position
  alias Rovers.Model.Rover, as: Rover

  @type statusPosition :: {__MODULE__.status(), Position}

  @doc """

  ### Examples

      iex> Resolver.runInstructions(
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

      iex> Resolver.runInstructions(
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

      iex> Resolver.runInstructions(
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
  @spec runInstructions(Rover.t(), [Position.instructions()], Grid.t()) :: Rover.t()
  def runInstructions(rover, instructions, grid) do
    case instructions do
      [] ->
        rover

      [instruction | instructions] ->
        rover = Rover.move(rover, instruction, grid)

        case newRover.status do
          :offGrid -> rover
          :ok -> runInstructions(rover, instructions, grid)
        end
    end
  end
end
