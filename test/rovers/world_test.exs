defmodule Rovers.WorldTest do
  use ExUnit.Case, async: true

  alias Rovers.World, as: World
  alias Rovers.Model.Rover, as: Rover
  alias Rovers.Model.Position, as: Position

  setup do
    {:ok, world} = World.start_link(%{})
    {:ok, world: world}
  end

  test "can create a rover on the grid", %{world: world} do
    position = Position.create(:north, 5, 5)

    assert {:ok, nil} == World.create_rover(world, "Ben", position)
    assert {:ok, %Rover{status: :ok, position: position}} == World.lookup_rover(world, "Ben")
  end

  test "cannot create a rover off the grid", %{world: world} do
    assert {:error, :offGrid} == World.create_rover(world, "Rob", Position.create(:north, 10, 10))
    assert {:error, :noRover} == World.lookup_rover(world, "Ben")
  end

  test "can move a rover", %{world: world} do
    World.create_rover(world, "Paul", Position.create(:north, 5, 5))
    World.move_rover(world, "Paul", :forward)
    World.move_rover(world, "Paul", :left)

    newRover = World.lookup_rover(world, "Paul")
    assert {:ok, %Rover{status: :ok, position: Position.create(:west, 5, 6)}} == newRover
  end
end
