defmodule KantoxWeb.Controllers.Requests.Products.Upsert do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  @required [:id, :name, :price]

  @primary_key {:id, :binary_id, autogenerate: false}
  embedded_schema do
    field(:name, :string)
    field(:price, :decimal)
    embeds_one(:promotion, KantoxWeb.Requests.Products.Upsert.Promotion)
  end

  def build(changeset \\ %__MODULE__{}, params) do
    changeset
    |> cast(params, @required)
    |> validate_required(@required)
    |> validate_number(:price, greater_than: 0)
    |> cast_embed(:promotion,
      with: fn mod, promo ->
        new_params = Map.put(promo, "discount_limit", Map.get(params, "price"))
        KantoxWeb.Requests.Products.Upsert.Promotion.changeset(mod, new_params)
      end
    )
    |> apply_action(:cast)
  end
end

defmodule KantoxWeb.Requests.Products.Upsert.Promotion do
  @moduledoc false

  use Ecto.Schema

  import EctoEnum
  import Ecto.Changeset

  @required [:elements, :discount, :condition]

  defenum(Condition,
    equal_to: 1,
    greater_than: 2
  )

  @primary_key false
  embedded_schema do
    field(:elements, :integer)
    field(:condition, Condition)
    field(:discount, :decimal)
    field(:discount_limit, :decimal)
  end

  def changeset(changeset \\ %__MODULE__{}, params) do
    changeset
    |> cast(params, [:discount_limit | @required])
    |> validate_required(@required)
    |> maybe_validate()
    |> validate_limit()
  end

  defp maybe_validate(%{changes: %{discount: val}} = changeset) when not is_nil(val) do
    validate_number(changeset, :discount, greater_than: 0)
  end

  defp maybe_validate(changeset), do: changeset

  defp validate_limit(%{changes: %{discount: val, discount_limit: limit}} = changeset) do
    if Decimal.compare(val, limit) == :gt do
      add_error(changeset, :discount, "Invalid discount amount, it exceeds the price")
    else
      changeset
    end
  end

  defp validate_limit(changeset), do: changeset
end
