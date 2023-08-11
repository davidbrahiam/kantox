defmodule KantoxWeb.Controllers.Requests.Products.Purchase do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  @required [:basket]

  @primary_key false
  embedded_schema do
    field(:basket, {:array, :string})
  end

  def build(changeset \\ %__MODULE__{}, params) do
    changeset
    |> cast(params, @required)
    |> validate_required(@required)
    |> apply_action(:cast)
  end
end
