defmodule Dhola.Command do
  @doc ~S"""
  Parses the given `line` into a command.

  ## Examples

      iex> Dhola.Command.parse "CREATE shopping\r\n"
      {:ok, {:create, "shopping"}}

      iex> Dhola.Command.parse "CREATE  shopping  \r\n"
      {:ok, {:create, "shopping"}}

      iex> Dhola.Command.parse "PUT shopping milk 1\r\n"
      {:ok, {:put, "shopping", "milk", "1"}}

      iex> Dhola.Command.parse "GET shopping milk\r\n"
      {:ok, {:get, "shopping", "milk"}}

      iex> Dhola.Command.parse "DELETE shopping eggs\r\n"
      {:ok, {:delete, "shopping", "eggs"}}

  Unknown commands or commands with the wrong number of
  arguments return an error:

      iex> Dhola.Command.parse "UNKNOWN shopping eggs\r\n"
      {:error, :unknown_command}

      iex> Dhola.Command.parse "GET shopping\r\n"
      {:error, :unknown_command}

  """
  def parse(line) do
    case String.split(line) do
      ["CREATE", bucket] -> {:ok, {:create, bucket}}
      ["GET", bucket, key] -> {:ok, {:get, bucket, key}}
      ["PUT", bucket, key, value] -> {:ok, {:put, bucket, key, value}}
      ["DELETE", bucket, key] -> {:ok, {:delete, bucket, key}}
      _ -> {:error, :unknown_command}
    end
  end

  @doc """
  Runs the given command
  """
  def run(command, socket)

  def run({:create, bucket}, socket) do
    Dhola.create_bucket(bucket)
    :gen_tcp.send(socket, "OK\r\n")
    :ok
  end

  def run({:get, bucket, key}, socket) do
    lookup(bucket, fn pid ->
      value = Dhola.Bucket.get(pid, key)
      :gen_tcp.send(socket, "#{value}\r\nOK\r\n")
      :ok
    end)
  end

  def run({:put, bucket, key, value}, socket) do
    lookup(bucket, fn pid ->
      Dhola.Bucket.put(pid, key, value)
      :gen_tcp.send(socket, "OK\r\n")
      :ok
    end)
  end

  def run({:delete, bucket, key}, socket) do
    lookup(bucket, fn pid ->
      Dhola.Bucket.delete(pid, key)
      :gen_tcp.send(socket, "OK\r\n")
      :ok
    end)
  end

  defp lookup(bucket, callback) do
    if bucket = Dhola.lookup_bucket(bucket) do
      callback.(bucket)
    else
      {:error, :not_found}
    end
  end
end
