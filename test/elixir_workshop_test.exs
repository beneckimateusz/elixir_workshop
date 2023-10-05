defmodule ElixirWorkshopTest do
  use ExUnit.Case
  doctest ElixirWorkshop

  test "greets the world" do
    assert ElixirWorkshop.hello() == :world
  end
end
