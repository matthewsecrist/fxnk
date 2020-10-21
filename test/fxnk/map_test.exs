defmodule Fxnk.MapTest do
  use ExUnit.Case
  use ExUnitProperties
  doctest Fxnk.Map

  import Fxnk.Map

  describe "pick/2" do
    test "returns an empty map when passed an empty map" do
      assert %{} = pick(%{}, [:foo])
    end

    test "returns an empty map when passed an empty array" do
      assert %{} = pick(%{foo: "bar"}, [])
    end
  end
end
