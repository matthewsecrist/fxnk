defmodule Fxnk.Flow do
  @moduledoc """
  `Fxnk.Flow` functions are used for control flow.
  """
  import Fxnk.Functions, only: [curry: 1]
  import Fxnk.List, only: [reduce_right: 3]

  @doc """
  `compose/1` returns a curried `Compose`

  ## Examples
      iex> reverseSort = Fxnk.Flow.compose([&Enum.reverse/1, &Enum.sort/1])
      iex> reverseSort.([1,3,5,7,6,4,2])
      [7, 6, 5, 4, 3, 2, 1]
  """
  @spec compose([function(), ...]) :: fun()
  def compose(fns) when is_list(fns) do
    curry(fn arg -> compose(arg, fns) end)
  end

  @doc """
  `compose/2` is a pipeable `Compose`.

  ## Examples
      iex> [1,3,5,7,6,4,2] |> Fxnk.Flow.compose([&Enum.reverse/1, &Enum.sort/1])
      [7, 6, 5, 4, 3, 2, 1]
  """
  @spec compose(any, [function(), ...]) :: any
  def compose(arg, fns) when is_list(fns) do
    reduce_right(fns, arg, fn f, acc -> f.(acc) end)
  end

  @doc """
  `pipe/1` returns a curried `Pipe`

  ## Examples
      iex> reverseSort = Fxnk.Flow.pipe([&Enum.sort/1, &Enum.reverse/1])
      iex> reverseSort.([1,3,5,7,6,4,2])
      [7, 6, 5, 4, 3, 2, 1]
  """
  @spec pipe([function(), ...]) :: fun()
  def pipe(fns) when is_list(fns) do
    curry(fn arg -> pipe(arg, fns) end)
  end

  @doc """
  `pipe/2` is a pipeable `Pipe`

  ## Examples
      iex> [1,3,5,7,6,4,2] |> Fxnk.Flow.pipe([&Enum.sort/1, &Enum.reverse/1])
      [7, 6, 5, 4, 3, 2, 1]
  """
  @spec pipe(any, [function(), ...]) :: any
  def pipe(arg, fns) when is_list(fns) do
    Enum.reduce(fns, arg, fn f, acc -> f.(acc) end)
  end

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
