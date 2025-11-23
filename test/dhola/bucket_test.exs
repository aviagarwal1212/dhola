defmodule Dhola.BucketTest do
  use ExUnit.Case, async: true

  test "stores values by key" do
    {:ok, bucket} = Dhola.Bucket.new([])
    assert Dhola.Bucket.get(bucket, "milk") == nil

    Dhola.Bucket.put(bucket, "milk", 1)
    assert Dhola.Bucket.get(bucket, "milk") == 1
  end

  test "stores values by key in a named process", config do
    {:ok, _} = Dhola.Bucket.new(name: config.test)
    assert Dhola.Bucket.get(config.test, "milk") == nil

    Dhola.Bucket.put(config.test, "milk", 1)
    assert Dhola.Bucket.get(config.test, "milk") == 1
  end
end
