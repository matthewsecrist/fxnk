defmodule Fxnk.Map do
  @moduledoc """
  `Fxnk.Map` are functions that work with maps.
  """
  import Fxnk.Functions, only: [curry: 1]

  @doc """
  Curried `assemble/2`

  ## Examples
      iex> map = %{red: "red", green: "green", blue: "blue" }
      iex> fnmap = %{
      ...> red: Fxnk.Flow.compose([&String.upcase/1, Fxnk.Map.prop(:red)]),
      ...> blue: Fxnk.Flow.compose([&String.reverse/1, Fxnk.Map.prop(:blue)])
      ...> }
      iex> assembler = Fxnk.Map.assemble(fnmap)
      iex> assembler.(map)
      %{red: "RED", blue: "eulb"}
  """
  @spec assemble(%{any() => function()}) :: (map() -> map())
  def assemble(fn_map) do
    fn map -> assemble(map, fn_map) end
  end

  @doc """
  Takes an initial map and a "builder" map where each value is a function. Builds a new map by setting the keys in the function map to
  the values returned by the function applied to the original map.

  ## Examples
      iex> map = %{red: "red", green: "green", blue: "blue" }
      iex> fnmap = %{
      ...> red: Fxnk.Flow.compose([&String.upcase/1, Fxnk.Map.prop(:red)]),
      ...> blue: Fxnk.Flow.compose([&String.reverse/1, Fxnk.Map.prop(:blue)])
      ...> }
      iex> Fxnk.Map.assemble(map, fnmap)
      %{red: "RED", blue: "eulb"}
  """
  @spec assemble(map(), %{any() => function()}) :: any()
  def assemble(map, fn_map) do
    fn_map
    |> Map.to_list()
    |> Enum.reduce(%{}, fn {key, function}, acc ->
      Map.put_new(acc, key, function.(map))
    end)
  end

  @doc """
  Takes a map and a function that accepts a map and returns a map. Runs the map against the function and merges the initial map into the result.

  ## Examples
      iex> map = %{red: "red", green: "green", blue: "blue"}
      iex> colorCombiner = Fxnk.Map.combine(fn %{red: red, blue: blue} -> %{purple: red <> blue} end)
      iex> colorCombiner.(map)
      %{red: "red", green: "green", blue: "blue", purple: "redblue"}
  """
  @spec combine((map() -> map())) :: (map() -> map())
  def combine(function) do
    fn map -> combine(map, function) end
  end

  @doc """
  Takes a map and a function that accepts a map and returns a map. Runs the map against the function and merges the initial map into the result.

  ## Examples
      iex> map = %{red: "red", green: "green", blue: "blue"}
      iex> colorCombiner = Fxnk.Functions.always(%{purple: "purple"})
      iex> Fxnk.Map.combine(map, colorCombiner)
      %{red: "red", green: "green", blue: "blue", purple: "purple"}
  """
  @spec combine(map(), (map() -> map())) :: map()
  def combine(map, function) do
    Map.merge(function.(map), map)
  end

  @doc """
  `combine/2` but also accepts a combining function as the last arguments.

  ## Examples
      iex> map = %{colors: %{red: "red", green: "green", blue: "blue"}}
      iex> colorCombiner = Fxnk.Functions.always(%{colors: %{red: "fire red", purple: "purple"}})
      iex> Fxnk.Map.combine_with(map, colorCombiner, &Fxnk.Map.merge_deep_right/2)
      %{colors: %{red: "fire red", green: "green", blue: "blue", purple: "purple"}}
  """
  @spec combine_with(map(), (map() -> map()), (map(), map() -> map())) :: map()
  def combine_with(map, function, combining_function) do
    apply(combining_function, [map, function.(map)])
  end

  @doc """
  Return a specific element in a nested map. If the path does not exist, returns the orignal map.

  ## Examples
      iex> map = %{one: %{two: %{three: "three" }}}
      iex> Fxnk.Map.path(map, [:one, :two, :three])
      "three"
      iex> Fxnk.Map.path(map, [:one, :two])
      %{three: "three"}
      iex> Fxnk.Map.path(map, [:one, :four])
      %{one: %{two: %{three: "three" }}}
  """
  @spec path(map(), [binary() | atom()]) :: map() | any()
  def path(map, path_array) do
    do_path(map, path_array, map)
  end

  @doc """
  Like `path/2`, but returns the `or_value` when the path is not found.

  ## Examples
      iex> map = %{one: %{two: %{three: "three" }}}
      iex> Fxnk.Map.path_or(map, [:one, :two, :three], :foo)
      "three"
      iex> Fxnk.Map.path_or(map, [:one, :two], :foo)
      %{three: "three"}
      iex> Fxnk.Map.path_or(map, [:one, :four], :foo)
      :foo
  """
  @spec path_or(map(), [binary() | atom()], any()) :: map() | any()
  def path_or(map, path_array, or_value) do
    do_path_or(map, path_array, or_value)
  end

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
    curry(fn map -> prop(map, key) end)
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
    curry(fn map -> props(map, keys) end)
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
  Curried `prop_equals/3`, takes a value, returns a function that accepts a map and a key.

  ## Examples
      iex> isFoo = Fxnk.Map.prop_equals("foo")
      iex> isFoo.(%{foo: "foo"}, :foo)
      true
  """
  @spec prop_equals(any()) :: (map(), atom() | String.t() -> boolean())
  def prop_equals(value) do
    fn map, key -> prop_equals(map, key, value) end
  end

  @doc """
  Curried `prop_equals/3`, takes a key and a value. Returns a function that accepts a map.

  ## Examples
      iex> isKeyFoo = Fxnk.Map.prop_equals(:foo, "foo")
      iex> isKeyFoo.(%{foo: "foo"})
      true
  """
  @spec prop_equals(atom | binary, any) :: (map() -> boolean())
  def prop_equals(key, value) when is_atom(key) or is_binary(key) do
    fn map -> prop_equals(map, key, value) end
  end

  @doc """
  Accepts a map, key and value. Checks to see if the key on the map is equal to the value.any()

  ## Examples
      iex> Fxnk.Map.prop_equals(%{foo: "foo"}, :foo, "foo")
      true
      iex> Fxnk.Map.prop_equals(%{foo: "bar"}, :foo, "foo")
      false
  """
  @spec prop_equals(map(), atom() | binary(), any()) :: boolean()
  def prop_equals(map, key, value) when is_map(map) and (is_binary(key) or is_atom(key)) do
    map[key] === value
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
    curry(fn map -> pick(map, args) end)
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
    curry(fn map -> has_prop?(map, property) end)
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
  Merges two maps together deeply. If both maps have the same key, the value on the right will be used.
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
  Merges two maps together deeply. If both maps have the same key, the value on the left will be used.
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

  @doc """
  Rename a key in a map, takes the map, current key and replacement key. Returns the original map with the updated key.

  ## Example
      iex> Fxnk.Map.rename(%{id: "1234"}, :id, :user_id)
      %{user_id: "1234"}
      iex> Fxnk.Map.rename(%{hello: "world", foo: "foo" }, :foo, :bar)
      %{hello: "world", bar: "foo"}
  """
  @spec rename(map(), String.t() | atom(), String.t() | atom()) :: map()
  def rename(map, key, new_key) do
    {value, popped_map} = Access.pop(map, key)

    Map.merge(popped_map, %{new_key => value})
  end

  @doc """
  Rename multiple keys in a map. Takes the original map and a map where the key is the original key and the value is the replacement key.

  ## Example
      iex> Fxnk.Map.rename_all(%{user_id: "1234", foo: "foo", bar: "bar"}, %{user_id: :id, bar: :baz})
      %{id: "1234", foo: "foo", baz: "bar"}
  """
  @spec rename_all(map(), map()) :: map()
  def rename_all(map, renames) do
    renames
    |> Map.to_list()
    |> Enum.reduce(map, fn {old, new}, acc -> rename(acc, old, new) end)
  end

  defp do_pick(_, [], acc), do: acc

  defp do_pick(map, [hd | tl], acc) do
    case Map.fetch(map, hd) do
      {:ok, val} -> do_pick(map, tl, Map.put(acc, hd, val))
      _ -> do_pick(map, tl, acc)
    end
  end

  defp do_path(map, _, nil), do: map
  defp do_path(_, [], acc), do: acc
  defp do_path(map, [hd | tl], acc), do: do_path(map, tl, prop(acc, hd))

  defp do_path_or(nil, _, default_to), do: default_to
  defp do_path_or(map, [], _), do: map
  defp do_path_or(map, [hd | tl], default_to), do: do_path_or(prop(map, hd), tl, default_to)
end
