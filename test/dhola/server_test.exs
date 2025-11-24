defmodule Dhola.ServerTest do
  require Logger
  use ExUnit.Case, async: true

  @socket_options [:binary, packet: :line, active: false]

  setup config do
    {:ok, socket} = :gen_tcp.connect(~c"localhost", 42069, @socket_options)
    test_name = config.test |> Atom.to_string() |> String.replace(" ", "-")
    %{socket: socket, name: "#{config.module}-#{test_name}"}
  end

  test "server interaction", %{socket: socket, name: name} = _config do
    assert send_and_recv(socket, "CREATE #{name}\r\n") == "OK\r\n"
    assert send_and_recv(socket, "PUT #{name} eggs 3\r\n") == "OK\r\n"
    assert send_and_recv(socket, "GET #{name} eggs\r\n") == "3\r\n"
    assert send_and_recv(socket, "") == "OK\r\n"
    assert send_and_recv(socket, "DELETE #{name} eggs\r\n") == "OK\r\n"
    assert send_and_recv(socket, "GET #{name} eggs\r\n") == "\r\n"
    assert send_and_recv(socket, "") == "OK\r\n"
  end

  test "unknown command", %{socket: socket} = _config do
    assert send_and_recv(socket, "WHATEVER\r\n") == "UNKNOWN COMMAND\r\n"
  end

  test "unknown bucket", %{socket: socket} = _config do
    assert send_and_recv(socket, "GET whatever eggs\r\n") == "NOT FOUND\r\n"
  end

  defp send_and_recv(socket, command) do
    :ok = :gen_tcp.send(socket, command)
    {:ok, data} = :gen_tcp.recv(socket, 0, 1000)
    data
  end
end
