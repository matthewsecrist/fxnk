defmodule Fxnk.Functions do
  @moduledoc """
  `Fxnk.Functions` are functions for computation or helpers.
  """
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
      iex> Fxnk.Functions.juxt([1,3,5,7], [&Fxnk.Math.min/1, &Fxnk.Math.max/1])
      [1, 7]
  """
  @spec juxt(any, [function(), ...]) :: any
  def juxt(arg, fns) do
    perform_juxt(arg, fns, [])
  end

  defp perform_juxt(arg, [hd | []], results), do: [hd.(arg) | results] |> Enum.reverse()
  defp perform_juxt(arg, [hd | tl], results), do: perform_juxt(arg, tl, [hd.(arg) | results])
end
