defmodule BusStop.BackgroundSearch do
  use GenServer

  @timeout 10_000

  def start(stop_id) do
    # check if background search by stop_id value it's already started
    case Process.whereis(stop_id) do
      nil -> GenServer.start_link(__MODULE__, [stop_id], name: stop_id)
    end
  end

  def init(stop_id) do
    {:ok, stop_id, @timeout}
  end

  def handle_info(:timeout, stop_id) do
    # do whatever I need to do


    GenServer.stop(self())

    {:noreply, stop_id, @timeout}
  end
end
