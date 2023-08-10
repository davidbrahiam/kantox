defmodule Kantox.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      KantoxWeb.Telemetry,
      Kantox.Cache.ETS,
      # Start the Endpoint (http/https)
      KantoxWeb.Endpoint

      # Start a worker by calling: Kantox.Worker.start_link(arg)
      # {Kantox.Worker, arg}
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
end
