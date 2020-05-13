defmodule Fxnk.Functions do
  @moduledoc """
  `Fxnk.Functions` are functions for computation or helpers.
  """

  @doc """
  `always/1` returns the value passed to it always.

  ## Examples
      iex> fourtyTwo = Fxnk.Functions.always(42)
      iex> fourtyTwo.("hello")
      42
  """
  @spec always(any()) :: function()
  def always(val), do: curry(fn _ -> val end)

  @doc """
  `always/2` returns the second value passed to it always.

  ## Examples
      iex> Fxnk.Functions.always("hello", 42)
      42
  """
  @spec always(any(), any()) :: any()
  def always(_, val), do: val

  @doc """
  `curry/1` takes a function and returns a function.

  ## Examples
      iex> add = Fxnk.Functions.curry(fn (a, b) -> a + b end)
      iex> add.(6).(7)
      13
      iex> addOne = Fxnk.Functions.curry(add.(1))
      iex> addOne.(1336)
      1337
  """
  @spec curry(function()) :: function()
  def curry(fun) do
    {_, arity} = :erlang.fun_info(fun, :arity)
    curry(fun, arity, [])
  end

  defp curry(fun, 0, arguments) do
    apply(fun, Enum.reverse(arguments))
  end

  defp curry(fun, arity, arguments) do
    fn arg -> curry(fun, arity - 1, [arg | arguments]) end
  end

  @doc """
  `juxt/1` takes list of functions and returns a curried juxt.

  ## Example
      iex> minmax = Fxnk.Functions.juxt([&Fxnk.Math.min/1, &Fxnk.Math.max/1])
      iex> minmax.([1,3,5,7])
      [1, 7]
  """
  @spec juxt([function(), ...]) :: function()
  def juxt(fns) when is_list(fns) do
    curry(fn arg -> juxt(arg, fns) end)
  end

  @doc """
  `juxt/2` takes an initial argument and list of functions and applies the functions to the argument.

  ## Example
      iex> Fxnk.Functions.juxt(%{foo: "foo", bar: "bar", baz: "baz"}, [Fxnk.Map.prop(:foo), Fxnk.Map.prop(:bar)])
      ["foo", "bar"]
  """
  @spec juxt(any, [function(), ...]) :: any
  def juxt(arg, fns) do
    for func <- fns, do: func.(arg)
  end

  @doc """
  `tap/1` takes a function and returns a function that takes a value. Applies the value to the function and then returns the value.
  """
  @spec tap(function()) :: function()
  def tap(func) do
    curry(fn val -> tap(val, func) end)
  end

  @doc """
  `tap/2` takes a value and a function, applies the value to the function and returns the value.
  """
  @spec tap(any(), function()) :: function()
  def tap(val, func) do
    func.(val)
    val
  end
end
