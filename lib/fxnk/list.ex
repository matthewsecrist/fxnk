defmodule Fxnk.List do
  @moduledoc """
  `Fxnk.List` are functions for working with lists.
  """

  @doc """
  `reduce_right/3` takes a list of args, an initial value and a function and returns a single value.

  Like reduce, it applies the function to each of the arguments, and accumulating the result, except it does it right to left.

  ## Examples
      iex> Fxnk.List.reduce_right([1,2,3,4,5], 0, fn a, b -> a + b end)
      15
  """
  @spec reduce_right(list(any), any, function()) :: any
  def reduce_right(args, initial, func) do
    args
    |> Enum.reverse()
    |> Enum.reduce(initial, func)
  end

  @doc """
  `zip_map/2` is a lot like `Enum.zip/2`, but instead of returning a list of tuples,
  it returns a list of maps, where the keys are the second list passed in.

  ## Examples
      iex> Fxnk.List.zip_map(["hello", "world"], ["first", "second"])
      [%{"first" => "hello"}, %{"second" => "world"}]
  """
  @spec zip_map(list(any), list(any)) :: [%{any() => any()}]
  def zip_map(list, keys) do
    list
    |> Enum.zip(keys)
    |> Enum.map(fn {v, k} -> %{k => v} end)
  end
end
