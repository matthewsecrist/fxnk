defmodule Fxnk.Map do
  @moduledoc """
  `Fxnk.Map` are functions that work with maps.
  """

  @doc """
  Accepts a string `key` and returns a function that takes a `map`. Returns the map's value at `key` or `nil`.

  ## Examples
      iex> getProp = Fxnk.Map.prop("foo")
      iex> getProp.(%{"foo" => "foo", "bar" => "bar"})
      "foo"
      iex> getProp2 = Fxnk.Map.prop(:foo)
      iex> getProp2.(%{foo: "foo", bar: "bar"})
      "foo"
  """
  @spec prop(atom() | binary()) :: (map() -> any())
  def prop(key) when is_binary(key) or is_atom(key) do
    fn map -> prop(map, key) end
  end

  @doc """
  Accepts a map and a key. Returns the map's value at `key` or `nil`

  ## Examples
      iex> Fxnk.Map.prop(%{"foo" => "foo", "bar" => "bar"}, "foo")
      "foo"
      iex> Fxnk.Map.prop(%{foo: "foo", bar: "bar"}, :foo)
      "foo"
  """
  @spec prop(map(), atom() | binary()) :: any()
  def prop(map, key) when is_map(map) and (is_binary(key) or is_atom(key)) do
    map[key]
  end

  @doc """
  Accepts a list of keys and returns a function that takes a map. Returns a list of the values associated with the keys in the map.

  ## Examples
      iex> getProps = Fxnk.Map.props(["foo", "bar"])
      iex> getProps.(%{"foo" => "foo", "bar" => "bar", "baz" => "baz"})
      ["foo", "bar"]
      iex> getProps2 = Fxnk.Map.props([:foo, :bar])
      iex> getProps2.(%{foo: "foo", bar: "bar", baz: "baz"})
      ["foo", "bar"]
  """
  @spec props([atom() | binary(), ...]) :: (map() -> [any(), ...])
  def props(keys) when is_list(keys) do
    fn map -> props(map, keys) end
  end

  @doc """
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
  Accepts a list of args, returns a curried `pick/2`.

  ## Examples
      iex> pickArgs = Fxnk.Map.pick([:red, :blue, :orange])
      iex> pickArgs.(%{ red: "RED", green: "GREEN", blue: "BLUE", yellow: "YELLOW" })
      %{red: "RED", blue: "BLUE"}
  """
  @spec pick([atom(), ...]) :: (map() -> map())
  def pick(args) when is_list(args) do
    fn map -> pick(map, args) end
  end

  @doc """
  `pick/2` takes a `Map` and a `List` of atoms, and returns a map of only the selected keys that exist. It will
  return an empty map if passed an empty map or an empty list.

  ## Examples
      iex> Fxnk.Map.pick(%{ red: "RED", green: "GREEN", blue: "BLUE", yellow: "YELLOW" }, [:red, :blue, :orange])
      %{red: "RED", blue: "BLUE"}
  """
  @spec pick(map(), [atom(), ...]) :: map()
  def pick(map, _) when map_size(map) == 0, do: map
  def pick(_, []), do: %{}

  def pick(map, args) when is_map(map) and is_list(args) do
    do_pick(map, args, %{})
  end

  @doc """
  Curried `has_prop?/2`

  ## Examples
      iex> hasFoo = Fxnk.Map.has_prop?(:foo)
      iex> hasFoo.(%{foo: 'foo'})
      true
      iex> hasFoo.(%{bar: 'bar'})
      false
  """
  @spec has_prop?(atom() | String.t()) :: (map() -> boolean())
  def has_prop?(property) when is_binary(property) or is_atom(property) do
    fn map -> has_prop?(map, property) end
  end

  @doc """
  Takes a map and a property, returns `true` if the property has a value in the map, `false` otherwise.

  ## Examples
      iex> Fxnk.Map.has_prop?(%{foo: "foo"}, :foo)
      true
      iex> Fxnk.Map.has_prop?(%{foo: "foo"}, :bar)
      false
  """
  @spec has_prop?(map(), atom() | String.t()) :: boolean()
  def has_prop?(map, property) when is_map(map) and (is_binary(property) or is_atom(property)) do
    prop(map, property) !== nil
  end

  @doc """
  Merges two maps together, if both maps have the same key, the value on the right will be used.

  ## Example
      iex> Fxnk.Map.merge_right(%{red: "red", blue: "blue"}, %{red: "orange", green: "green"})
      %{red: "orange", blue: "blue", green: "green"}
  """
  @spec merge_right(map(), map()) :: map()
  def merge_right(map1, map2) do
    Map.merge(map1, map2)
  end

  @doc """
  Merges two maps together deeply. If both maps have the wame key, the value on the right will be used.
  If both keys are a map, the maps will be merged together recursively, preferring values on the right.

  ## Example
      iex> map1 = %{red: "red", green: %{green: "green", yellowish: "greenish", with_blue: %{turqoise: "blueish green"}}, blue: "blue"}
      iex> map2 = %{red: "orange", green: %{green: "blue and yellow", yellowish: "more yellow than green"}}
      iex> Fxnk.Map.merge_deep_right(map1, map2)
      %{red: "orange", green: %{green: "blue and yellow", yellowish: "more yellow than green", with_blue: %{turqoise: "blueish green"}}, blue: "blue"}
  """
  @spec merge_deep_right(map(), map()) :: map()
  def merge_deep_right(map1, map2) do
    Map.merge(map1, map2, fn _, v1, v2 ->
      if is_map(v1) and is_map(v2) do
        merge_deep_right(v1, v2)
      else
        v2
      end
    end)
  end

  @doc """
  Merges two maps together, if both maps have the same key, the value on the left will be used.

  ## Example
      iex> Fxnk.Map.merge_left(%{red: "red", blue: "blue"}, %{red: "orange", green: "green"})
      %{red: "red", blue: "blue", green: "green"}
  """
  @spec merge_left(map(), map()) :: map()
  def merge_left(map1, map2) do
    Map.merge(map2, map1)
  end

  @doc """
  Merges two maps together deeply. If both maps have the wame key, the value on the left will be used.
  If both keys are a map, the maps will be merged together recursively, preferring values on the left.

  ## Example
      iex> map1 = %{red: "red", green: %{green: "green", yellowish: "greenish", with_blue: %{turqoise: "blueish green"}}, blue: "blue"}
      iex> map2 = %{red: "orange", green: %{green: "blue and yellow", yellowish: "more yellow than green"}}
      iex> Fxnk.Map.merge_deep_left(map1, map2)
      %{red: "red", green: %{green: "green", yellowish: "greenish", with_blue: %{turqoise: "blueish green"}}, blue: "blue"}
  """
  @spec merge_deep_left(map(), map()) :: map()
  def merge_deep_left(map1, map2) do
    merge_deep_right(map2, map1)
  end

  defp do_pick(_, [], acc), do: acc

  defp do_pick(map, [hd | tl], acc) do
    case Map.fetch(map, hd) do
      {:ok, val} -> do_pick(map, tl, Map.put(acc, hd, val))
      _ -> do_pick(map, tl, acc)
    end
  end
end
