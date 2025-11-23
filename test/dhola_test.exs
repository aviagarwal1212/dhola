defmodule DholaTest do
  use ExUnit.Case
  doctest Dhola

  test "creates and looks up a bucket by any name", config do
    assert is_nil(Dhola.lookup_bucket(config.test))

    assert {:ok, bucket} = Dhola.create_bucket(config.test)
    assert Dhola.lookup_bucket(config.test) == bucket

    assert Dhola.create_bucket(config.test) == {:error, {:already_started, bucket}}
  end
end
