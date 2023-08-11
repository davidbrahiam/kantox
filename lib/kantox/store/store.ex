defmodule Kantox.Store do
  @moduledoc false

  @adapter Application.compile_env(:kantox, __MODULE__, Kantox.Store.ETS)

  @callback insert(atom(), tuple() | map()) :: :ok
  defdelegate insert(table, item), to: @adapter

  @callback delete(atom(), integer()) :: :ok
  defdelegate delete(table, id), to: @adapter

  @callback get_by_id(atom(), integer()) :: {:ok, map()} | {:error, any()}
  defdelegate get_by_id(table, id), to: @adapter


  @callback all(atom()) :: list()
  defdelegate all(table), to: @adapter

  @callback clear_data(atom()) :: :ok
  defdelegate clear_data(table), to: @adapter
end
