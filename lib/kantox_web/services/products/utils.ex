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
            discount: decimal_to_string(promotion.discount),
            condition: Atom.to_string(promotion.condition),
            elements: promotion.elements
          }
      end

    %{
      id: product.id,
      name: product.name,
      price: decimal_to_string(product.price),
      promotion: promotion
    }
  end

  def atom_to_string(nil), do: nil

  def atom_to_string(atom) when is_atom(atom) do
    Atom.to_string(atom)
  end

  def atom_to_string(atom), do: atom

  def decimal_to_string(nil), do: nil

  def decimal_to_string(value) when is_number(value) do
    "#{value}"
  end

  def decimal_to_string(value) when is_binary(value) do
    value
  end

  def decimal_to_string(value) do
    if Decimal.is_decimal(value) do
      Decimal.to_string(value)
    else
      nil
    end
  end
end
