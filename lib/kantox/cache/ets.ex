defmodule Kantox.Cache.ETS do
  @moduledoc false
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    table = :persistent_term.get(:products_table)
    table_name = :ets.new(table, [:named_table, :set, :public, read_concurrency: true])

    {:ok, table_name}
  end
end
