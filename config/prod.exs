import Config

config :scl_bus_stop_info, SclBusStopInfo.Router.Main,
  server: true,
  http: [
    port: 4000,
    transport_options: [socket_opts: [:inet6]]
  ],
  url: [host: System.get_env("APP_NAME") <> ".gigalixirapp.com", port: 443]
  check_origin: ["https://" <> System.get_env("APP_NAME") <> ".gigalixirapp.com"]
