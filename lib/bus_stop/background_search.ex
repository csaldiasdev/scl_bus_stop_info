defmodule BusStop.BackgroundSearch do
  alias BusStop.Search
  use GenServer

  @timeout 5_000

  def start(stop_id) do
    case Registry.register(BackgroundProcess, stop_id, []) do
      {:ok, _} ->
        IO.puts("STARTING A NEW BACKGROUND PROCESS: #{stop_id}")

        GenServer.start_link(__MODULE__, [stop_id, []], [])

      _ ->
        IO.puts("PROCESS ALREADY RUNNING: #{stop_id}")
    end
  end

  def init([stop_id, _]) do
    case Search.get_prediction(stop_id) do
      %{predictions: data} -> {:ok, [stop_id, data], @timeout}
      _ -> {:ok, [stop_id, []], @timeout}
    end

    {:ok, [stop_id, []], @timeout}
  end

  def handle_info(:timeout, [stop_id, state_data]) do

    IO.puts("FETCHING STOP INFO: #{stop_id}")

    case Search.get_prediction(stop_id) do
      %{predictions: data} ->

        if Registry.count_match(ConnectionStop, stop_id, []) > 0 do
          Registry.dispatch(ConnectionStop, stop_id, fn entries ->
            for {pid, _} <- entries, do: send(pid, Jason.encode!(data))
          end)
        else
          IO.puts("CALLING Process.exit - #{stop_id}")
          Process.exit(self(), [])
        end

        {:noreply, [stop_id, data], @timeout}

      _ ->
        {:noreply, [stop_id, state_data], @timeout}
    end
  end

  def terminate(_, [stop_id, _]) do
    IO.puts("TERMINATING PROCESS - #{stop_id}")

    case Registry.unregister(BackgroundProcess, stop_id) do
      :ok ->
        IO.puts("PROCESS TERMINATED SUCCESSFULY - #{stop_id}")
    end
  end
end
