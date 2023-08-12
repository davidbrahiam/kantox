defmodule Kantox.Models.Promotion do
  @moduledoc false

  use Ecto.Schema

  import EctoEnum
  import Ecto.Changeset

  @required [:elements, :discount, :condition]

  defenum(Condition,
    get_elements_pay_discount: 1,
    greater_than: 2
  )

  @primary_key false
  embedded_schema do
    field(:elements, :integer)
    field(:condition, Condition)
    field(:discount, :decimal)
  end

  def changeset(changeset \\ %__MODULE__{}, params) do
    changeset
    |> cast(params, @required)
    |> validate_required(@required)
    |> validate_number(:elements, greater_than: 0)
    |> maybe_validate()
    |> validate_limit(params)
  end

  defp maybe_validate(%{changes: %{discount: val}} = changeset) when not is_nil(val) do
    validate_number(changeset, :discount, greater_than: 0)
  end

  defp maybe_validate(changeset), do: changeset

  defp validate_limit(%{changes: %{discount: val}} = changeset, %{"discount_limit" => limit}) do
    limit = Kantox.Utils.to_decimal(limit)

    if Decimal.compare(val, limit) == :gt do
      add_error(changeset, :discount, "Invalid discount amount, it exceeds the price")
    else
      changeset
    end
  end

  defp validate_limit(changeset, _), do: changeset
end
