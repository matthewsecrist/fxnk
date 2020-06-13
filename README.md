# fxnk

Fxnk is a functional programming library for Elixir inspired by Ramda.

[![Actions Status](https://github.com/matthewsecrist/fxnk/workflows/test/badge.svg)](https://github.com/matthewsecrist/fxnk/actions)

[![Coverage Status](https://coveralls.io/repos/github/matthewsecrist/fxnk/badge.svg?branch=master)](https://coveralls.io/github/matthewsecrist/fxnk?branch=master)

It includes functions for flow, lists, logic, maps, and math. Typically, you'd just want to import what you need, such as `import Fxnk.Flow, only: [if_else: 4]`.

And then you would use it like this:

```elixir
defmodule Something.Cool do
  import Fxnk.Flow, only: [if_else: 4]

  def do_stuff(a, b, c) do
    a
    |> foo(b)
    |> bar(c)
    |> if_else(is_awesome?, do_awesome_stuff/1, make_awesome/1)
  end
end
```

Fxnk's functions are also curried for easy reading.

```elixir
  iex> import Fxnk.Flow
  iex> import Fxnk.Logic
  iex> import Fxnk.Math
  iex> isGreaterThan5? = gt?(5)
  iex> isLessThan10? = lt?(10)
  iex> isGreaterThan5AndLessThan10? = both?(isGreaterThan5?, isLessThan10?)
  iex> isGreaterThan5AndLessThan10?.(8)
  true
  iex> timesTwo = multiply(2)
  iex> multiplyByTwoIfBetween5and10 = when_is(isGreaterThan5AndLessThan10?, timesTwo)
  iex> multiplyByTwoIfBetween5and10.(8)
  16
```

You also don't need to predefine the functions to use them.

```elixir
  iex> import Fxnk.Flow
  iex> import Fxnk.Logic
  iex> import Fxnk.Math
  iex> multiplyByTwoIfBetween5and10 = when_is(both?(gt?(5), lt?(10)), multiply(2))
  iex> multiplyByTwoIfBetween5and10.(8)
  16
```
