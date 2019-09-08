defmodule Fxnk.MapTest do
  use ExUnit.Case
  doctest Fxnk.Map

  import Fxnk.Map

  test "returns an empty map when passed an empty map" do
    assert %{} = pick(%{}, [:foo])
  end

  test "returns an empty map when passed an empty array" do
    assert %{} = pick(%{foo: "bar"}, [])
  end
end
