defmodule JuxtTest do
  use ExUnit.Case
  doctest Fxnk.Juxt
  import Fxnk.Juxt
  import Fxnk.Math

  test "curried juxt works with a list" do
    fns = [&min/1, &max/1]
    minmax = juxt(fns)
    assert minmax.([1, 2, 3, 4, 5]) == [1, 5]
  end

  test "pipeable juxt works with a list" do
    fns = [&min/1, &max/1]
    result = [1, 2, 3, 4, 5] |> juxt(fns)
    assert result == [1, 5]
  end
end
