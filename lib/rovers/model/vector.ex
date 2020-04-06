defmodule Rovers.Model.Vector do
  @type t :: %__MODULE__{
          x: integer,
          y: integer
        }

  @enforce_keys [:x, :y]
  defstruct [:x, :y]

  @doc """
  Sums two vectors by adding there individual x and y components separately

  ## Examples

      iex> Vector.add(%Vector{x: 1, y: 2}, %Vector{x: 3, y: 4})
      %Vector{x: 4, y: 6}

      iex> Vector.add(%Vector{x: 3, y: -3}, %Vector{x: -7, y: 0})
      %Vector{x: -4, y: -3}

  """
  @spec add(__MODULE__.t(), __MODULE__.t()) :: __MODULE__.t()
  def add(a, b) do
    %__MODULE__{x: a.x + b.x, y: a.y + b.y}
  end
end
