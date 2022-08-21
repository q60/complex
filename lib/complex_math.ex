defprotocol ComplexMath do
  @moduledoc """
  Complex math protocol.

  This protocol is responsible for extending math operators to work with complex numbers.
  """

  def -a
  def a + b
  def a - b
  def a * b
  def a / b
  def a ** b
  def abs(a)
end

defimpl ComplexMath, for: [Complex, Integer, Float] do
  def -a, do: Complex.op(a, :erlang.-(1), :*)
	def a + b, do: Complex.op(a, b, :+)
	def a - b, do: Complex.op(a, b, :-)
	def a * b, do: Complex.op(a, b, :*)
	def a / b, do: Complex.op(a, b, :/)
	def a ** b, do: Complex.op(a, b, :**)
  def abs(a), do: Complex.op(a, :abs)
end
