defmodule SclBusStopInfo.Router.WS do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/stop/:stop_id" do
    conn
    |> WebSockAdapter.upgrade(WsHub.EchoServer, stop_id, timeout: :infinity)
    |> halt()
  end

  match _ do
    send_resp(conn, 404, Jason.encode!(%{message: "not found"}))
  end

end
