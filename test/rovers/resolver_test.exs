defmodule Rovers.ResolverTest do
  use ExUnit.Case, async: true
  alias Rovers.Model.Vector, as: Vector
  alias Rovers.Model.Grid, as: Grid
  alias Rovers.Model.Position, as: Position
  alias Rovers.Model.Rover, as: Rover
  alias Rovers.Resolver, as: Resolver

  doctest Resolver
end
