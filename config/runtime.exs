import Config

port =
  cond do
    port_env = System.get_env("PORT") -> String.to_integer(port_env)
    true -> 42069
  end

config :dhola, :port, port
