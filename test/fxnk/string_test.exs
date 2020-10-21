defmodule StringTest do
  use ExUnit.Case
  use ExUnitProperties
  doctest Fxnk.String

  describe "concat/2" do
    property "concatenates two strings" do
      check all s1 <- StreamData.string(:printable),
                s2 <- StreamData.string(:printable) do
        assert s1 <> s2 === Fxnk.String.concat(s1, s2)
      end
    end
  end
end
