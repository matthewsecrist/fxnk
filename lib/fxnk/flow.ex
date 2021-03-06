defmodule Fxnk.Flow do
  @moduledoc """
  `Fxnk.Flow` functions are used for control flow.
  """
  import Fxnk.Functions, only: [curry: 1]
  import Fxnk.List, only: [reduce_right: 3]

  @doc """
  `and_then/2` allows you to chain together `{:ok, _}` functions. Stops processing on the first `{:error, _}` and returns the error.

  ## Examples
      iex> map = %{foo: "foo", bar: "bar", baz: "baz"}
      iex> uppercase_okay = fn str -> {:ok, String.upcase(str) } end
      iex> reverse_okay = fn str -> {:ok, String.reverse(str)} end
      iex> map |> Map.fetch(:foo) |> Fxnk.Flow.and_then(uppercase_okay) |> Fxnk.Flow.and_then(reverse_okay)
      {:ok, "OOF"}
      iex> throw_error = fn _ -> {:error, :input_should_not_be_foo} end
      iex> map |> Map.fetch(:foo) |> Fxnk.Flow.and_then(throw_error) |> Fxnk.Flow.and_then(reverse_okay)
      {:error, :input_should_not_be_foo}

  """
  @spec and_then({:error, any} | {:ok, any}, function()) :: any
  def and_then({:ok, arg}, func), do: func.(arg)
  def and_then({:error, error}, _), do: {:error, error}

  @doc """
  Curried `compose/2`.

  ## Examples
      iex> reverseSort = Fxnk.Flow.compose([&Enum.reverse/1, &Enum.sort/1])
      iex> reverseSort.([1,3,5,7,6,4,2])
      [7, 6, 5, 4, 3, 2, 1]
  """
  @spec compose([function(), ...]) :: (any() -> any())
  def compose(fns) when is_list(fns) do
    curry(fn arg -> compose(arg, fns) end)
  end

  @doc """
  `compose/2` takes an input and a list of functions and runs the functions against the input
  from right to left.

  ## Examples
      iex> [1,3,5,7,6,4,2] |> Fxnk.Flow.compose([&Enum.reverse/1, &Enum.sort/1])
      [7, 6, 5, 4, 3, 2, 1]
  """
  @spec compose(any, [function(), ...]) :: any()
  def compose(arg, fns) when is_list(fns) do
    reduce_right(fns, arg, fn f, acc -> f.(acc) end)
  end

  @doc """
  Curried `if_else/3`

  ## Examples
      iex> multTwoIfLessThanTenOrDivideByTwo = Fxnk.Flow.if_else(fn x -> x < 10 end, fn x -> x * 2 end, fn x -> div(x, 2) end)
      iex> multTwoIfLessThanTenOrDivideByTwo.(5)
      10
      iex> multTwoIfLessThanTenOrDivideByTwo.(20)
      10
  """
  @spec if_else(function(), function(), function()) :: (any() -> any())
  def if_else(pred, passFunc, failFunc) do
    curry(fn input -> if_else(input, pred, passFunc, failFunc) end)
  end

  @doc """
  `if_else/4` takes an input, a predicate, a pass function and a fail function.
  Runs the pass function if the predicate returns true when passed the input, otherwise runs the fail function.

  ## Examples
      iex> Fxnk.Flow.if_else(5, fn x -> x < 10 end, fn x -> x * 2 end, fn x -> div(x, 2) end)
      10
      iex> Fxnk.Flow.if_else(20, fn x -> x < 10 end, fn x -> x * 2 end, fn x -> div(x, 2) end)
      10
  """
  @spec if_else(any, function(), function(), function()) :: (any() -> any())
  def if_else(input, pred, passFunc, failFunc) do
    case pred.(input) do
      true -> passFunc.(input)
      _ -> failFunc.(input)
    end
  end

  @doc """
  Curried `pipe/2`.

  ## Examples
      iex> reverseSort = Fxnk.Flow.pipe([&Enum.sort/1, &Enum.reverse/1])
      iex> reverseSort.([1,3,5,7,6,4,2])
      [7, 6, 5, 4, 3, 2, 1]
  """
  @spec pipe([function(), ...]) :: (any() -> any())
  def pipe(fns) when is_list(fns) do
    curry(fn arg -> pipe(arg, fns) end)
  end

  @doc """
  `pipe/2` takes an input and a list of functions and runs the functions against the input
  from left to right.

  ## Examples
      iex> [1,3,5,7,6,4,2] |> Fxnk.Flow.pipe([&Enum.sort/1, &Enum.reverse/1])
      [7, 6, 5, 4, 3, 2, 1]
  """
  @spec pipe(any, [function(), ...]) :: any()
  def pipe(arg, fns) when is_list(fns) do
    Enum.reduce(fns, arg, fn f, acc -> f.(acc) end)
  end

  @doc """
  Handle errors gracefully. When an error is encountered, apply a function to that error. When its not an error, do nothing.

  ## Example:
      iex> make_error = fn message -> {:error, message} end
      iex> handle_error = fn message -> Atom.to_string(message) end
      iex> make_error.(:foo) |> Fxnk.Flow.on_error(handle_error)
      "foo"
      iex> make_success = fn message -> {:ok, message} end
      iex> make_success.(:bar) |> Fxnk.Flow.on_error(handle_error)
      {:ok, :bar}
  """
  @spec on_error({:error, any()} | any(), function()) :: any()
  def on_error({:error, x}, func), do: func.(x)
  def on_error(x, _), do: x

  @doc """
  Curried `unless_is/3`.

  ## Examples
      iex> multiplyByTwoUnlessGreaterThan10 = Fxnk.Flow.unless_is(fn n -> n > 10 end, fn x -> x * 2 end)
      iex> multiplyByTwoUnlessGreaterThan10.(15)
      15
      iex> multiplyByTwoUnlessGreaterThan10.(2)
      4
  """
  @spec unless_is(function(), function()) :: (any() -> any())
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
  @spec unless_is(any, function(), function()) :: any()
  def unless_is(input, pred, func) do
    case pred.(input) do
      true -> input
      _ -> func.(input)
    end
  end

  @doc """
  Curried `until/3`.

  ## Examples
      iex> timesTwoUntilGreaterThan100 = Fxnk.Flow.until(fn x -> x > 100 end, fn n -> n * 2 end)
      iex> timesTwoUntilGreaterThan100.(1)
      128
  """
  @spec until(function(), function()) :: (any() -> any())
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
  @spec until(any, function(), function()) :: any()
  def until(init, pred, func) do
    case pred.(init) do
      false -> until(func.(init), pred, func)
      _ -> init
    end
  end

  @doc """
  Curried `when_is/3`.

  ## Examples
      iex> timesTwoWhenGreaterThan10 = Fxnk.Flow.when_is(fn x -> x > 10 end, fn n -> n * 2 end)
      iex> timesTwoWhenGreaterThan10.(15)
      30
      iex> timesTwoWhenGreaterThan10.(5)
      5
  """
  @spec when_is(function(), function()) :: (any() -> any())
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
  @spec when_is(any, function(), function()) :: any()
  def when_is(input, pred, func) do
    case pred.(input) do
      true -> func.(input)
      _ -> input
    end
  end
end
