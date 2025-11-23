defmodule DholaTest do
  use ExUnit.Case
  doctest Dhola

  test "greets the world" do
    assert Dhola.hello() == :world
  end
end
