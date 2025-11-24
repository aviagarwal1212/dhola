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
    port = Application.fetch_env!(:dhola, :port)

    children = [
      # spawn registry process for application
      {Registry, name: Dhola, keys: :unique},
      # dynamic supervisor for each bucket
      {DynamicSupervisor, name: Dhola.BucketSupervisor, strategy: :one_for_one},
      # task supervisor for better `Task` ergonomics
      {Task.Supervisor, name: Dhola.ServerSupervisor},
      # start the server when the application is started
      Supervisor.child_spec({Task, fn -> Dhola.Server.accept(port) end}, restart: :permanent)
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end

  @doc """
  Creates a bucket with the given name.
  """
  def create_bucket(name) do
    DynamicSupervisor.start_child(Dhola.BucketSupervisor, {Dhola.Bucket, name: via(name)})
  end

  @doc """
  Looks up the given bucket.
  """
  def lookup_bucket(name) do
    via(name) |> GenServer.whereis()
  end

  defp via(name) do
    {:via, Registry, {Dhola, name}}
  end
end
