defmodule Fxnk.Map do
  @moduledoc """
  `Fxnk.Map` are functions that work with maps.
  """
  import Fxnk.Functions, only: [curry: 1]

  @doc """
  `prop/1`

  Accepts a string `key` and returns a function that takes a `map`.
  Returns the map's value at `key` or `nil`.

  ## Examples
      iex> getProp = Fxnk.Map.prop("foo")
      iex> getProp.(%{"foo" => "foo", "bar" => "bar"})
      "foo"
      iex> getProp2 = Fxnk.Map.prop(:foo)
      iex> getProp2.(%{foo: "foo", bar: "bar"})
      "foo"
  """
  @spec prop(atom() | binary()) :: function()
  def prop(key) do
    curry(fn map -> prop(map, key) end)
  end

  @doc """
  `prop/2`

  Accepts a map and a key. Returns the map's value at `key` or `nil`

  ## Examples
      iex> Fxnk.Map.prop(%{"foo" => "foo", "bar" => "bar"}, "foo")
      "foo"
      iex> Fxnk.Map.prop(%{foo: "foo", bar: "bar"}, :foo)
      "foo"
  """
  @spec prop(map(), atom() | binary()) :: any()
  def prop(map, key) when is_map(map) do
    map[key]
  end

  @doc """
  `props/1`

  Accepts a list of keys and returns a function that takes a map.
  Returns a list of the values associated with the keys in the map.

  ## Examples
      iex> getProps = Fxnk.Map.props(["foo", "bar"])
      iex> getProps.(%{"foo" => "foo", "bar" => "bar", "baz" => "baz"})
      ["foo", "bar"]
      iex> getProps2 = Fxnk.Map.props([:foo, :bar])
      iex> getProps2.(%{foo: "foo", bar: "bar", baz: "baz"})
      ["foo", "bar"]
  """
  @spec props([atom() | binary(), ...]) :: function()
  def props(keys) when is_list(keys) do
    curry(fn map -> props(map, keys) end)
  end

  @doc """
  `props/2`

  Accepts a map and a list of keys and returns a list of the values associated with the keys in the map.

  ## Examples
      iex> Fxnk.Map.props(%{"foo" => "foo", "bar" => "bar", "baz" => "baz"}, ["foo", "bar"])
      ["foo", "bar"]
      iex> Fxnk.Map.props(%{foo: "foo", bar: "bar", baz: "baz"}, [:foo, :bar])
      ["foo", "bar"]
  """
  @spec props(map(), [atom() | binary(), ...]) :: [any(), ...]
  def props(map, keys) when is_list(keys) and is_map(map) do
    for key <- keys, do: prop(map, key)
  end

  @doc """
  `pick/1`

  Accepts a list of args, returns a curried `pick/2`.

  ## Examples
      iex> pickArgs = Fxnk.Map.pick([:red, :blue, :orange])
      iex> pickArgs.(%{ red: "RED", green: "GREEN", blue: "BLUE", yellow: "YELLOW" })
      %{red: "RED", blue: "BLUE"}
  """
  @spec pick([atom(), ...]) :: fun
  def pick(args) when is_list(args) do
    curry(fn map -> pick(map, args) end)
  end

  @doc """
  `pick/2` takes a `Map` and a `List` of atoms, and returns a map of only the selected keys that exist. It will
  return an empty map if passed an empty map or an empty list.

  ## Examples
      iex> Fxnk.Map.pick(%{ red: "RED", green: "GREEN", blue: "BLUE", yellow: "YELLOW" }, [:red, :blue, :orange])
      %{red: "RED", blue: "BLUE"}
  """
  @spec pick(map, [atom(), ...]) :: map
  def pick(map, _) when map_size(map) == 0, do: map
  def pick(_, []), do: %{}

  def pick(map, args) when is_map(map) and is_list(args) do
    do_pick(map, args, %{})
  end

  defp do_pick(_, [], acc), do: acc

  defp do_pick(map, [hd | tl], acc) do
    case Map.fetch(map, hd) do
      {:ok, val} -> do_pick(map, tl, Map.put(acc, hd, val))
      _ -> do_pick(map, tl, acc)
    end
  end
end
