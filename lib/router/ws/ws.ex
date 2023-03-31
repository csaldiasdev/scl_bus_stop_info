defmodule SclBusStopInfo.Router.WS do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/" do
    send_resp(conn, 200, "TESINGGGG WS")
  end

  match _ do
    send_resp(conn, 200, "NOT FOUND WS")
  end

end
