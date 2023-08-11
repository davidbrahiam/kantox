defmodule Kantox.Models.Product do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  @required [:id, :name, :price]

  @primary_key {:id, :binary_id, autogenerate: false}
  embedded_schema do
    field(:name, :string)
    field(:price, :decimal)
    embeds_one(:promotion, Kantox.Models.Promotion)
  end

  def build(changeset \\ %__MODULE__{}, params) do
    changeset
    |> cast(params, @required)
    |> validate_required(@required)
    |> validate_number(:price, greater_than: 0)
    |> cast_embed(:promotion,
      with: fn mod, promo ->
        new_params =
          case Map.keys(promo) do
            [k | _] when is_binary(k) ->
              Map.put(promo, "discount_limit", Map.get(params, "price"))

            [k | _] when is_atom(k) ->
              Map.put(promo, :discount_limit, Map.get(params, :price))

            _ ->
              promo
          end

        Kantox.Models.Promotion.changeset(mod, new_params)
      end
    )
    |> apply_action(:cast)
  end
end
