defmodule WsHub.EchoServer do
  def init(stop_id) do
    pid = self()

    IO.puts(Jason.encode!(%{stop_id: stop_id, pid: inspect(pid)}))

    Registry.register(ConnectionStop, stop_id, [])

    {:ok, stop_id}
  end

  def handle_in({data, [opcode: :text]}, state) do
    {:reply, :ok, {:text, data}, state}
  end

  def handle_info(message, state) do
    {:reply, :ok, {:text, message}, state}
  end

  def terminate(:timeout, state) do
    IO.puts("Connection closed by timeout")

    Registry.unregister(ConnectionStop, state)
    {:ok, state}
  end

  def terminate({:error, :closed}, state) do
    IO.puts("Connection closed")

    Registry.unregister(ConnectionStop, state)
    {:ok, state}
  end
end
