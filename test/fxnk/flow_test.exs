defmodule Fxnk.FlowTest do
  use ExUnit.Case
  doctest Fxnk.Flow
  import Fxnk.Flow

  test "curried compose works with a list" do
    reverse_sort = compose([&Enum.reverse/1, &Enum.sort/1])
    sorted = reverse_sort.([1, 3, 5, 7, 6, 4, 2])
    assert sorted == [7, 6, 5, 4, 3, 2, 1]
  end

  test "pipeable compose" do
    sorted = compose([1, 3, 5, 7, 6, 4, 2], [&Enum.reverse/1, &Enum.sort/1])
    assert sorted == [7, 6, 5, 4, 3, 2, 1]
  end

  test "curried pipe works with a list" do
    reverse_sort = pipe([&Enum.sort/1, &Enum.reverse/1])
    sorted = reverse_sort.([1, 3, 5, 7, 6, 4, 2])
    assert sorted == [7, 6, 5, 4, 3, 2, 1]
  end

  test "pipeable pipe" do
    sorted = pipe([1, 3, 5, 7, 6, 4, 2], [&Enum.sort/1, &Enum.reverse/1])
    assert sorted == [7, 6, 5, 4, 3, 2, 1]
  end
end
