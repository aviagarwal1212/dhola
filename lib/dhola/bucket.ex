defmodule Dhola.Bucket do
  use Agent

  @doc """
  Starts a new bucket.

  All options are forwarded to `Agent.start_link/2`.
  """
  def new(opts) do
    Agent.start_link(fn -> %{} end, opts)
  end

  @doc """
  Redirect `start_link` to `new`
  """
  def start_link(opts) do
    new(opts)
  end

  @doc """
  Gets a value from `bucket` by `key`.
  """
  def get(bucket, key) do
    Agent.get(bucket, &Map.get(&1, key))
  end

  @doc """
  Puts the `value` for the given `key` in the `bucket`.
  """
  def put(bucket, key, value) do
    Agent.update(bucket, &Map.put(&1, key, value))
  end

  @doc """
  Deletes `key` from `bucket`.

  Returns the current value of `key` if it exists.
  """
  def delete(bucket, key) do
    Agent.get_and_update(bucket, &Map.pop(&1, key))
  end
end
