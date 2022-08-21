# qcomplex

Elixir library implementing complex numbers and math.

The library adds new type of `t:complex/0` numbers and basic math operations for them. Complex numbers can also interact with integers and floats. Actually this library expands existing functions, so they can work with complex numbers too. Number operations available:

* addition
* subtraction
* multiplication
* division
* exponentiation
* absolute value
* trigonometric functions

## Installation

qcomplex is [available in Hex](https://hex.pm/packages/qcomplex) and can be installed by adding `qcomplex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:complex, "~> 0.1.0", hex: :qcomplex}
  ]
end
```

The docs can be found at <https://hexdocs.pm/qcomplex>.
