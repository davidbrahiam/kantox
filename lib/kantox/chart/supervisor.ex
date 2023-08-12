defmodule Kantox.Chart.Supervisor do
  @moduledoc false

  use DynamicSupervisor

  def start_link(__init_args) do
    DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_workers() do
    workers = Application.get_env(:kantox, :charts)

    :persistent_term.put(:charts_users, Enum.map(workers, &Atom.to_string/1))

    Enum.map(workers, fn worker ->
      child_spec =
        Supervisor.child_spec(Kantox.Chart.Worker,
          id: worker,
          start: {Kantox.Chart.Worker, :start_link, [[name: worker]]}
        )

      DynamicSupervisor.start_child(__MODULE__, child_spec)
    end)
  end

  def stop_workers() do
    workers = Application.get_env(:kantox, :charts)

    __MODULE__
    |> DynamicSupervisor.which_children()
    |> Enum.filter(fn {_, _, _, [module]} -> module in workers end)
    |> Enum.each(fn {_, pid, _, _} -> DynamicSupervisor.terminate_child(__MODULE__, pid) end)
  end
end
