defmodule Kantox.Cache.ETS do
  @moduledoc false
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    table = Application.get_env(:kantox, :products_table, :products)
    table_name = :ets.new(table, [:named_table, :set, :public, read_concurrency: true])
    :persistent_term.put(:products_table, table)

    {:ok, table_name}
  end
end
