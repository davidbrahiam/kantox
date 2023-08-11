defmodule Kantox.Utils do
  @moduledoc """
  Generic module that contains methods/helpers to be used acrross the project
  """

  require Decimal

  def to_decimal(val) when is_number(val), do: Decimal.new("#{val}")
  def to_decimal(val) when is_binary(val), do: Decimal.new(val)

  def to_decimal(val) do
    if Decimal.is_decimal(val) do
      val
    else
      :error
    end
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
