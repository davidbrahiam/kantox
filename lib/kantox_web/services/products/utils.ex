defmodule KantoxWeb.Services.Products.Utils do
  @moduledoc """
  Module that contains some helpers methods than can be used across
  others products services
  """

  require Decimal

  def format_product(product) do
    promotion =
      case Map.get(product, :promotion) do
        nil ->
          nil

        promotion ->
          %{
            discount: Kantox.Utils.decimal_to_string(promotion.discount),
            condition: Kantox.Utils.atom_to_string(promotion.condition),
            elements: promotion.elements
          }
      end

    %{
      id: product.id,
      name: product.name,
      price: Kantox.Utils.decimal_to_string(product.price),
      promotion: promotion
    }
  end
end
