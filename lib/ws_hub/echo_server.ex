defmodule WsHub.EchoServer do
  def init(stop_id) do
    pid = self()

    IO.puts(Jason.encode!(%{stop_id: stop_id, pid: inspect(pid)}))

    Registry.register(ConnectionStop, stop_id, [])

    BusStop.SearchTrigger.start_background_search(stop_id)

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
    unreg_conn_stop(state)
  end

  def terminate(:remote, state) do
    IO.puts("Connection closed by remote")
    unreg_conn_stop(state)
  end

  def terminate({:error, :closed}, state) do
    IO.puts("Connection closed")
    unreg_conn_stop(state)
  end

  defp unreg_conn_stop(state) do
    Registry.unregister(ConnectionStop, state)
    {:ok, state}
  end
end
