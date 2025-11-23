defmodule Dhola.BucketTest do
  use ExUnit.Case, async: true

  test "stores values by key" do
    {:ok, bucket} = start_supervised(Dhola.Bucket)
    assert Dhola.Bucket.get(bucket, "milk") == nil

    Dhola.Bucket.put(bucket, "milk", 1)
    assert Dhola.Bucket.get(bucket, "milk") == 1
  end

  test "stores values by key in a named process", config do
    {:ok, _} = start_supervised({Dhola.Bucket, name: config.test})
    assert Dhola.Bucket.get(config.test, "milk") == nil

    Dhola.Bucket.put(config.test, "milk", 1)
    assert Dhola.Bucket.get(config.test, "milk") == 1
  end

  test "deletes values by key" do
    {:ok, bucket} = start_supervised(Dhola.Bucket)
    Dhola.Bucket.put(bucket, "milk", 1)
    assert Dhola.Bucket.get(bucket, "milk") == 1

    assert Dhola.Bucket.delete(bucket, "milk") == 1
    assert Dhola.Bucket.get(bucket, "milk") == nil
  end
end
