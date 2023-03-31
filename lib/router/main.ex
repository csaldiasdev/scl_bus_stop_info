defmodule SclBusStopInfo.Router.Main do
  use Plug.Router

  plug :match
  plug :dispatch

  forward "/api/v1", to: SclBusStopInfo.Router.Api
  forward "/ws/v1", to: SclBusStopInfo.Router.WS

  match _ do
    send_resp(conn, 200, "NOT FOUND")
  end
end
