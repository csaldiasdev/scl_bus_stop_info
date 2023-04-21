defmodule BusStop.Search do
  import SweetXml

  @ws_url "http://ws13.smsbus.cl/wspatentedos/services/PredictorParaderoServicioWS"

  @headers [
    {"Content-Type", "application/xml"},
    {"SOAPAction", ""}
  ]

  @mapping predictions: [
             ~x"//item"l,
             service_code: ~x"./servicio/text()"s,
             service_response: ~x"./respuestaServicio/text()"s,
             response_code: ~x"./codigorespuesta/text()"s,
             bus_distance_1: ~x"./distanciabus1/text()"I,
             bus_distance_2: ~x"./distanciabus2/text()"I,
             bus_prediction_1: ~x"./horaprediccionbus1/text()"s,
             bus_prediction_2: ~x"./horaprediccionbus2/text()"s,
             bus_plate_1: ~x"./ppubus1/text()"s,
             bus_plate_2: ~x"./ppubus2/text()"s
           ]

  def get_prediction(stop_code) do
    xml_body = ~s"""
    <soapenv:Envelope
      xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:pred="http://predParaderoServicioWS.ws.simtws.wirelessiq.cl">
      <soapenv:Header/>
      <soapenv:Body>
        <pred:predictorParaderoServicio>
          <pred:paradero>#{stop_code}</pred:paradero>
          <pred:servicio></pred:servicio>
          <pred:cliente>0</pred:cliente>
          <pred:resolucion></pred:resolucion>
          <pred:ipUsuarioFinal></pred:ipUsuarioFinal>
          <pred:webTransId></pred:webTransId>
        </pred:predictorParaderoServicio>
      </soapenv:Body>
    </soapenv:Envelope>
    """

    case Finch.build(:post, @ws_url, @headers, xml_body) |> Finch.request(SMSBusWebService) do
      {:ok, %Finch.Response{body: body, status: 200}} -> xmap(body, @mapping) |> format_response
      _ -> :error
    end
  end

  defp format_response(response) do
    case response do
      %{predictions: data} ->
        data_1 =
          Enum.map(data, fn element ->
            %{
              bus_distance: element.bus_distance_1,
              bus_prediction: element.bus_prediction_1,
              bus_plate: element.bus_plate_1,
              service_code: element.service_code,
              service_response: element.service_response,
              response_code: element.response_code
            }
          end)

        data_2 =
          Enum.map(data, fn element ->
            %{
              bus_distance: element.bus_distance_2,
              bus_prediction: element.bus_prediction_2,
              bus_plate: element.bus_plate_2,
              service_code: element.service_code,
              service_response: element.service_response,
              response_code: element.response_code
            }
          end)

        list =
          Enum.concat(data_1, data_2)
          |> Enum.sort_by(& &1.bus_distance, :asc)
          |> Enum.filter(fn e ->
            !(e.bus_distance === 0 && e.bus_plate === "" && e.bus_prediction === "" &&
                e.service_response === "")
          end)
          |> Enum.uniq()

        available = Enum.filter(list, fn e -> e.bus_distance > 0 end)
        not_available = Enum.filter(list, fn e -> e.bus_distance === 0 end)

        {:ok, Enum.concat(available, not_available)}

      _ ->
        :empty
    end
  end
end
