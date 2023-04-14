import Config

config :scl_bus_stop_info, SclBusStopInfo.Endpoint,
  server: true,
  http: [port: {:system, "PORT"}],
  url: [host: System.get_env("APP_NAME") <> ".gigalixirapp.com", port: 443]
  check_origin: ["https://" <> System.get_env("APP_NAME") <> ".gigalixirapp.com"]
