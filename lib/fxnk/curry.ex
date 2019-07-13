defmodule Fxnk.Curry do
  @moduledoc """
  Documentation for Curry
  """

  @doc """
  `curry/1` takes a function and returns a function.

  ## Examples
      iex> import Fxnk.Curry
      Fxnk.Curry
      iex> add = curry(fn (a, b) -> a + b end)
      #Function<0.93910723/1 in Fxnk.Curry.curry/3>
      iex> add.(6).(7)
      13
      iex> addOne = curry(add.(1))
      #Function<0.93910723/1 in Fxnk.Curry.curry/3>
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
end
