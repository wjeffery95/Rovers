defmodule Rovers.Resolver do
  alias Rovers.Model, as: RM

  @type statusPosition :: {__MODULE__.status(), RM.Position}

  @doc """

  ### Examples

      iex> Resolver.runInstructions(
      ...>   %Position{direction: :north, vector: %Vector{x: 2, y: 2}},
      ...>   [:left, :forward, :right, :forward],
      ...>   %Grid{width: 5, height: 5}
      ...> )
      {:ok, %Position{direction: :north, vector: %Vector{x: 1, y: 3}}}

      iex> Resolver.runInstructions(
      ...>   %Position{direction: :east, vector: %Vector{x: 7, y: 4}},
      ...>   [:forward, :forward, :right, :forward],
      ...>   %Grid{width: 9, height: 6}
      ...> )
      {:offGrid, %Position{direction: :east, vector: %Vector{x: 8, y: 4}}}

      iex> Resolver.runInstructions(
      ...>   %Position{direction: :west, vector: %Vector{x: 4, y: 4}},
      ...>   [:forward, :forward, :right, :forward, :forward, :left, :forward, :right],
      ...>   %Grid{width: 6, height: 9}
      ...> )
      {:ok, %Position{direction: :north, vector: %Vector{x: 1, y: 6}}}

  """
  @spec runInstructions(RM.Position.t(), [RM.Position.instructions()], RM.Grid.t()) ::
          __MODULE__.statusPosition()
  def runInstructions(position, instructions, grid) do
    case instructions do
      [] ->
        {:ok, position}

      [instruction | instructions] ->
        case getNewPositionStatus(position, instruction, grid) do
          {:offGrid, _} -> {:offGrid, position}
          {:ok, newPosition} -> runInstructions(newPosition, instructions, grid)
        end
    end
  end

  @spec getNewPositionStatus(RM.Position.t(), RM.Position.instruction(), RM.Grid.t()) ::
          __MODULE__.statusPosition()
  defp getNewPositionStatus(position, instruction, grid) do
    newPosition = RM.Position.executeInstruction(position, instruction)
    {RM.Grid.onGrid?(grid, newPosition.vector), newPosition}
  end
end
