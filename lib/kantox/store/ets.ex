defmodule Kantox.Store.ETS do
  @moduledoc false
  @behaviour Kantox.Store

  @table Application.compile_env(:kantox, :default_table)

  @impl true
  def insert(item) do
    true = :ets.insert(@table, item)
    :ok
  end

  @impl true
  def delete(id) do
    true = :ets.delete(@table, id)
    :ok
  end

  @impl true
  def get_by_id(id) do
    query = [{{:"$1", :"$2"}, [{:==, :"$1", id}], [:"$2"]}]

    case :ets.select(@table, query) do
      [val | _] -> val
      _ -> nil
    end
  end

  @impl true
  def all() do
    query = [{{:"$1", :"$2"}, [], [{{:"$1", :"$2"}}]}]
    :ets.select(@table, query)
  end

  @impl true
  def clear_data() do
    true = :ets.delete_all_objects(@table)
    :ok
  end
end
