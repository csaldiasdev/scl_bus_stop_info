defmodule SclBusStopInfo.Router.Api do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get "/stop/:code" do
    case BusStop.Search.get_prediction(code) do
      :error -> send_resp(conn, 500, "ERROR 1")
      data -> send_resp(conn, 200, Jason.encode!(data.predictions))
    end
  end

  match _ do
    send_resp(conn, 200, "NOT FOUND API")
  end
end
