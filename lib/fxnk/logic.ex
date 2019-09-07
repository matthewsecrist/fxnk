defmodule Fxnk.Logic do
  import Fxnk.Curry

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

  @spec ifElse(function(), function(), function()) :: fun
  def ifElse(pred, passFunc, failFunc) do
    curry(fn input -> ifElse(input, pred, passFunc, failFunc) end)
  end

  @spec ifElse(any, function(), function(), function()) :: any
  def ifElse(input, pred, passFunc, failFunc) do
    case pred.(input) do
      true -> passFunc.(input)
      _ -> failFunc.(input)
    end
  end

  @spec isEmpty(any) :: boolean
  def isEmpty([]), do: true
  def isEmpty(%{}), do: true
  def isEmpty(_), do: false

  @spec not?(any) :: fun
  def not?(x), do: curry(fn y -> not?(x, y) end)

  @spec not?(any, any) :: boolean
  def not?(x, x), do: false
  def not?(_, _), do: true

  @spec or?(any) :: fun
  def or?(x), do: curry(fn y -> or?(x, y) end)

  @spec or?(any, any) :: boolean
  def or?(true, _), do: true
  def or?(_, true), do: true
  def or?(_, _), do: false

  @spec unless_is(function(), function()) :: fun
  def unless_is(pred, func) do
    curry(fn input -> unless_is(input, pred, func) end)
  end

  @spec unless_is(any, function(), function()) :: any
  def unless_is(input, pred, func) do
    case pred.(input) do
      true -> input
      _ -> func.(input)
    end
  end

  @spec until(function(), function()) :: fun
  def until(pred, func) do
    curry(fn init -> until(init, pred, func) end)
  end

  @spec until(any, function(), function()) :: any
  def until(init, pred, func) do
    case pred.(init) do
      false -> until(func.(init), pred, func)
      _ -> init
    end
  end

  @spec when_is(function(), function()) :: fun
  def when_is(pred, func) do
    curry(fn input -> when_is(input, pred, func) end)
  end

  @spec when_is(any, function(), function()) :: any
  def when_is(input, pred, func) do
    case pred.(input) do
      true -> func.(input)
      _ -> input
    end
  end
end
