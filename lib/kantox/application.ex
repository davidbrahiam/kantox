defmodule Kantox.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    load_config()
    initial_children = [Kantox.Cache.ETS] ++ warmers()

    children =
      initial_children ++
        [
          # Start the Telemetry supervisor
          KantoxWeb.Telemetry,
          # Start the Endpoint (http/https)
          KantoxWeb.Endpoint
        ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Kantox.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    KantoxWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp load_config() do
    table = Application.get_env(:kantox, :products_table, :products)
    :persistent_term.put(:products_table, table)
  end

  defp warmers() do
    Application.get_env(:kantox, :warmers, [])
  end
end
