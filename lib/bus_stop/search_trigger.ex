defmodule BusStop.SearchTrigger do
  alias BusStop.BackgroundSearch
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def start_background_search(stop_id) do
    GenServer.cast(__MODULE__, {:start_background_search, stop_id})
  end

  def init(_) do
    {:ok, []}
  end

  def handle_cast({:start_background_search, stop_id}, _) do
    BackgroundSearch.start(stop_id)
    {:noreply, []}
  end
end
