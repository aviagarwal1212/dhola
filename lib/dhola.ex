defmodule Dhola do
  @moduledoc """
  Documentation for `Dhola`.
  """

  use Application

  @doc """
  Starts a supervisor that spawns a process registry.
  """
  @impl true
  def start(_type, _args) do
    children = [{Registry, name: Dhola, keys: :unique}]
    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
