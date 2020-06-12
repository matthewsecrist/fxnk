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
  @spec always(any()) :: any()
  def always(val), do: fn _ -> val end

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
  Curried `converge/3`

  ## Example
    iex> reverseUpcaseConcat = Fxnk.Functions.converge(&Fxnk.String.concat/2, [&String.reverse/1, &String.upcase/1])
    iex> reverseUpcaseConcat.("hello")
    "ollehHELLO"
  """
  @spec converge(function(), [function(), ...]) :: (any() -> any())
  def converge(to_fn, fns) do
    curry(fn args -> converge(args, to_fn, fns) end)
  end

  @doc """
  `converge/3` takes an initial argument, a function and a list of functions. It applies the argument to each of the list of functions
  and then applies the results of those functions as the argument to the end function.

  The end function must have the same arity as the length of the list of functions.

  ## Example
      iex> Fxnk.Functions.converge("hello", &Fxnk.String.concat/2, [&String.reverse/1, &String.upcase/1])
      "ollehHELLO"
  """
  @spec converge(any(), function(), [function(), ...]) :: any()
  def converge(args, to_fn, fns) do
    results = for function <- fns, do: function.(args)

    apply(to_fn, results)
  end

  @doc """
  A function that always returns false.
  """
  @spec falsy :: false
  def falsy do
    false
  end

  @doc """
  Takes a function, returns a function that takes the same args as the initial function, but flips the order of the arguments.

  ## Example
      iex> flippedConcatString = Fxnk.Functions.flip(&Fxnk.String.concat/2)
      iex> Fxnk.String.concat("hello", "world")
      "helloworld"
      iex> flippedConcatString.("hello", "world")
      "worldhello"
  """
  @spec flip(function()) :: (any(), any() -> any())
  def flip(func) do
    fn arg1, arg2 -> func.(arg2, arg1) end
  end

  @doc """
  Same as `flip/1`, but takes the arguments at the same time as the function.

  ## Example
      iex> Fxnk.Functions.flip("hello", "world", &Fxnk.String.concat/2)
      "worldhello"
  """
  @spec flip(any(), any(), function()) :: any()
  def flip(arg1, arg2, func) do
    flip(func).(arg1, arg2)
  end

  @doc """
  `identity/1` returns what was passed to it.

  ## Example
      iex> Fxnk.Functions.identity(42)
      42
  """
  @spec identity(any()) :: any()
  def identity(arg) do
    arg
  end

  @doc """
  `juxt/1` takes list of functions and returns a curried juxt.

  ## Example
      iex> minmax = Fxnk.Functions.juxt([&Fxnk.Math.min/1, &Fxnk.Math.max/1])
      iex> minmax.([1,3,5,7])
      [1, 7]
  """
  @spec juxt([function(), ...]) :: (any() -> any())
  def juxt(fns) when is_list(fns) do
    curry(fn arg -> juxt(arg, fns) end)
  end

  @doc """
  `juxt/2` takes an initial argument and list of functions and applies the functions to the argument.

  ## Example
      iex> Fxnk.Functions.juxt(%{foo: "foo", bar: "bar", baz: "baz"}, [Fxnk.Map.prop(:foo), Fxnk.Map.prop(:bar)])
      ["foo", "bar"]
  """
  @spec juxt(any, [function(), ...]) :: any()
  def juxt(arg, fns) do
    for func <- fns, do: func.(arg)
  end

  @doc """
  Function that always returns true.

  ## Example
      iex> Fxnk.Functions.truthy()
      true
  """
  @spec truthy :: true
  def truthy do
    true
  end

  @doc """
  `tap/1` takes a function and returns a function that takes a value. Applies the value to the function and then returns the value.

  ## Example
      iex> function = Fxnk.Functions.tap(&Fxnk.Math.inc/1)
      iex> function.(42)
      42
  """
  @spec tap(function()) :: (any() -> any())
  def tap(func) do
    curry(fn val -> tap(val, func) end)
  end

  @doc """
  `tap/2` takes a value and a function, applies the value to the function and returns the value.

  ## Example
      iex> Fxnk.Functions.tap(42, &Fxnk.Math.inc/1)
      42
  """
  @spec tap(any(), function()) :: (any() -> any())
  def tap(val, func) do
    func.(val)
    val
  end
end
