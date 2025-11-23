defmodule Dhola.BucketTest do
  use ExUnit.Case, async: true

  test "stores values by key" do
    {:ok, bucket} = Dhola.Bucket.new([])
    assert Dhola.Bucket.get(bucket, "milk") == nil

    Dhola.Bucket.put(bucket, "milk", 1)
    assert Dhola.Bucket.get(bucket, "milk") == 1
  end
end
