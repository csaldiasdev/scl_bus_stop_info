defmodule SclBusStopInfo.Router.Api do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get "/stop/:code" do
    case BusStop.Search.get_prediction(code) do
      {:ok, data} -> send_resp(conn, 200, Jason.encode!(data))
      :error -> send_resp(conn, 500, Jason.encode!(%{message: "error fetching data"}))
      _ -> send_resp(conn, 500, Jason.encode!(%{message: "unexpected error"}))
    end
  end

  get "/stop/:code/listeners" do
    reg_status =
      Registry.select(ConnectionStop, [
        {{:"$1", :"$2", :"$3"}, [], [{{:"$1", :"$2", :"$3"}}]}
      ])
      # Filter must be done on select
      |> Enum.filter(fn {key, _, _} -> key == code end)
      # Convertion must be done on select
      |> Enum.map(fn {key, pid, value} -> %{key: key, pid: inspect(pid), value: value} end)

    send_resp(conn, 200, Jason.encode!(reg_status))
  end

  match _ do
    send_resp(conn, 404, Jason.encode!(%{message: "not found"}))
  end
end
