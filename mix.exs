defmodule SclBusStopInfo.MixProject do
  use Mix.Project

  def project do
    [
      app: :scl_bus_stop_info,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {SclBusStopInfo.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:bandit, "~> 0.6"},
      {:websock_adapter, "~> 0.5.0"},
      {:finch, "~> 0.15"},
      {:sweet_xml, "~> 0.7.1"},
      {:jason, "~> 1.4"}
    ]
  end
end
