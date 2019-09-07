defmodule Fxnk.Logic do
  @moduledoc """
  `Fxnk.Logic` are functions for dealing with booleans.
  """
  import Fxnk.Functions, only: [curry: 1]

  @doc """
  Curried `and?/2`

  ## Examples
      iex> isTwo? = Fxnk.Logic.and?(2)
      iex> isTwo?.(2)
      true
      iex> isTwo?.(3)
      false
  """
  @spec and?(any) :: fun
  def and?(x) do
    curry(fn y -> and?(x, y) end)
  end

  @spec and?(any, any) :: boolean
  def and?(x, x), do: true
  def and?(_, _), do: false

  @spec both?(function(), function()) :: fun
  def both?(func1, func2) do
    curry(fn input -> both?(input, func1, func2) end)
  end

  @spec both?(function(), function(), any) :: boolean
  def both?(input, func1, func2) do
    func1.(input) && func2.(input)
  end

  @spec complement(any) :: boolean
  def complement(x), do: !x

  @spec default_to(any) :: fun
  def default_to(x), do: curry(fn y -> default_to(y, x) end)

  @spec default_to(any, any) :: any
  def default_to(x, y) do
    case x do
      false -> y
      nil -> y
      _ -> x
    end
  end

  @spec either?(function(), function()) :: fun
  def either?(func1, func2) do
    curry(fn input -> either?(input, func1, func2) end)
  end

  @spec either?(any, function(), function()) :: any
  def either?(input, func1, func2) do
    func1.(input) || func2.(input)
  end

  @spec if_else(function(), function(), function()) :: fun
  def if_else(pred, passFunc, failFunc) do
    curry(fn input -> if_else(input, pred, passFunc, failFunc) end)
  end

  @spec if_else(any, function(), function(), function()) :: any
  def if_else(input, pred, passFunc, failFunc) do
    case pred.(input) do
      true -> passFunc.(input)
      _ -> failFunc.(input)
    end
  end

  @spec is_empty(any) :: boolean
  def is_empty([]), do: true
  def is_empty(%{}), do: true
  def is_empty(_), do: false

  @spec is_not?(any) :: fun
  def is_not?(x), do: curry(fn y -> is_not?(x, y) end)

  @spec is_not?(any, any) :: boolean
  def is_not?(x, x), do: false
  def is_not?(_, _), do: true

  @spec or?(any) :: fun
  def or?(x), do: curry(fn y -> or?(x, y) end)

  @spec or?(any, any) :: boolean
  def or?(true, _), do: true
  def or?(_, true), do: true
  def or?(_, _), do: false
end
