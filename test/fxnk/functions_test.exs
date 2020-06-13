defmodule Fxnk.FunctionsTest do
  use ExUnit.Case
  doctest Fxnk.Functions, except: [juxt_async: 3, map_async: 3]
  import Fxnk.Functions
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

  test "juxt async works with a list" do
    fn1 = fn x ->
      :timer.sleep(100)
      x + 1
    end

    fn2 = fn x ->
      :timer.sleep(100)
      x + 2
    end

    result = juxt_async(2, [fn1, fn2])
    assert result === [3, 4]
  end

  test "map async works with a list" do
    func = fn x ->
      :timer.sleep(100)
      x + 2
    end

    result = map_async([1, 2, 3, 4, 5], func)
    assert result === [3, 4, 5, 6, 7]
  end
end
