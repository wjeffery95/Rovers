defmodule Rovers.Model.Grid do
  alias Rovers.Model.Vector, as: Vector

  @type status :: :ok | :offGrid

  @type t :: %__MODULE__{
          width: integer,
          height: integer
        }

  @enforce_keys [:width, :height]
  defstruct [:width, :height]

  @doc """

  ### Examples

      iex> Grid.onGrid?(%Grid{width: 5, height: 5}, %Vector{x: 1, y: 1})
      :ok

      iex> Grid.onGrid?(%Grid{width: 3, height: 3}, %Vector{x: -1, y: 1})
      :offGrid

      iex> Grid.onGrid?(%Grid{width: 3, height: 3}, %Vector{x: 3, y: 1})
      :offGrid

      iex> Grid.onGrid?(%Grid{width: 9, height: 6}, %Vector{x: 0, y: 6})
      :offGrid

      iex> Grid.onGrid?(%Grid{width: 4, height: 2}, %Vector{x: 1, y: -5})
      :offGrid

      iex> Grid.onGrid?(%Grid{width: 9, height: 6}, %Vector{x: 8, y: 5})
      :ok

  """
  @spec onGrid?(__MODULE__.t(), Vector.t()) :: __MODULE__.status()
  def onGrid?(%{width: width, height: height}, %{x: x, y: y}) do
    if x < width && x > 0 && y < height && y > 0 do
      :ok
    else
      :offGrid
    end
  end
end
