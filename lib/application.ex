defmodule SclBusStopInfo.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Finch, name: SMSBusWebService},
      {Registry, keys: :duplicate, name: ConnectionStop, partitions: System.schedulers_online()},
      {Registry, keys: :unique, name: BackgroundProcess, partitions: System.schedulers_online()},
      {Bandit, plug: SclBusStopInfo.Router.Main, scheme: :http, options: [port: 4000]},
      {BusStop.SearchTrigger, []}
    ]

    opts = [strategy: :one_for_one, name: SclBusStopInfo.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
