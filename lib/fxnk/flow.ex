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

  @doc """
  Curried `unless_is/3`
  """
  @spec unless_is(function(), function()) :: fun
  def unless_is(pred, func) do
    curry(fn input -> unless_is(input, pred, func) end)
  end

  @doc """
  `unless_is` is a logic flow function, which takes an input, a predicate function, and an action function,
  allowing the action function to run unless the input returns true when ran against the predicate.

  ## Example
      iex> Fxnk.Flow.unless_is(15, fn n -> n > 10 end, fn x -> x * 2 end)
      15
      iex> Fxnk.Flow.unless_is(2, fn n -> n > 10 end, fn x -> x * 2 end)
      4
  """
  @spec unless_is(any, function(), function()) :: any
  def unless_is(input, pred, func) do
    case pred.(input) do
      true -> input
      _ -> func.(input)
    end
  end

  @doc """
  Curried `until/3`

  ## Examples
      iex> timesTwoUntilGreaterThan100 = Fxnk.Flow.until(fn x -> x > 100 end, fn n -> n * 2 end)
      iex> timesTwoUntilGreaterThan100.(1)
      128
  """
  @spec until(function(), function()) :: fun
  def until(pred, func) do
    curry(fn init -> until(init, pred, func) end)
  end

  @doc """
  `until/3` takes an input, a predicate function and an action function,
  running the action function on the input until the predicate is satisfied.

  ## Examples
      iex> Fxnk.Flow.until(1, fn x -> x > 100 end, fn n -> n * 2 end)
      128
  """
  @spec until(any, function(), function()) :: any
  def until(init, pred, func) do
    case pred.(init) do
      false -> until(func.(init), pred, func)
      _ -> init
    end
  end

  @doc """
  Curried `when_is/3`

  ## Examples
      iex> timesTwoWhenGreaterThan10 = Fxnk.Flow.when_is(fn x -> x > 10 end, fn n -> n * 2 end)
      iex> timesTwoWhenGreaterThan10.(15)
      30
      iex> timesTwoWhenGreaterThan10.(5)
      5
  """
  @spec when_is(function(), function()) :: fun
  def when_is(pred, func) do
    curry(fn input -> when_is(input, pred, func) end)
  end

  @doc """
  `when_is` is a logic flow function, which takes an input, a predicate function, and an action function,
  allowing the action function to run when the input returns true when ran against the predicate.

  ## Examples
      iex> Fxnk.Flow.when_is(15, fn x -> x > 10 end, fn n -> n * 2 end)
      30
      iex> Fxnk.Flow.when_is(5, fn x -> x > 10 end, fn n -> n * 2 end)
      5
  """
  @spec when_is(any, function(), function()) :: any
  def when_is(input, pred, func) do
    case pred.(input) do
      true -> func.(input)
      _ -> input
    end
  end
end
