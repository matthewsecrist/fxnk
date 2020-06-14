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
  @spec reduce_right(list(any), any, function()) :: any()
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
    keys
    |> Enum.zip(list)
    |> Enum.map(fn {k, v} -> %{k => v} end)
  end

  @doc """
  Takes two lists and returns a map where the keys are the elements from the first list and the values are the elements from the second.

  ## Examples
      iex> Fxnk.List.reduce_map([1, 2, 3], [:one, :two, :three])
      %{one: 1, two: 2, three: 3}
  """
  @spec reduce_map([any(), ...], [any()]) :: %{any() => any()}
  def reduce_map(values, keys) do
    keys
    |> Enum.zip(values)
    |> Enum.reduce(%{}, fn {key, value}, acc ->
      Map.merge(acc, %{key => value})
    end)
  end

  @doc """
  Takes two lists and returns a map where the keys are the elements from the second list and the values are the elements from the first.

  ## Examples
      iex> Fxnk.List.reduce_map_right([:one, :two, :three], [1, 2, 3])
      %{one: 1, two: 2, three: 3}
  """
  @spec reduce_map_right([any()], [any(), ...]) :: %{any() => any()}
  def reduce_map_right(keys, values) do
    reduce_map(values, keys)
  end

  @doc """
  Takes a list of maps and a key, returns a list of values in the key over all the maps

  ## Examples
      iex> list = [%{user_id: "1234"}, %{user_id: "4567"}, %{user_id: "6789"}]
      iex> Fxnk.List.pluck(list, :user_id)
      ["1234", "4567", "6789"]
  """
  @spec pluck([map(), ...], binary() | atom()) :: [any()]
  def pluck(list, property) do
    list
    |> Enum.map(fn map -> Fxnk.Map.prop(map, property) end)
  end
end
