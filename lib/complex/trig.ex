defmodule Complex.Trig do
  import Complex

  @spec sin(number()) :: float()
  def sin(x) when is_number(x), do: :math.sin(x)

  @spec sin(Complex.complex()) :: Complex.complex()
  def sin(z) when is_complex(z) do
    ComplexMath.+(
      :math.sin(z.re) * :math.cosh(z.im),
      ib(:math.cos(z.re) * :math.sinh(z.im))
    )
  end

  @spec cos(number()) :: float()
  def cos(x) when is_number(x), do: :math.cos(x)

  @spec cos(Complex.complex()) :: Complex.complex()
  def cos(z) when is_complex(z) do
    z = conj(z)

    ComplexMath.+(
      :math.cos(z.re) * :math.cosh(z.im),
      ib(:math.sin(z.re) * :math.sinh(z.im))
    )
  end

  @spec sinh(number()) :: float()
  def sinh(x) when is_number(x), do: :math.sinh(x)

  @spec sinh(Complex.complex()) :: Complex.complex()
  def sinh(z) when is_complex(z) do
    ComplexMath.+(
      :math.cos(z.im) * :math.sinh(z.re),
      ib(:math.sin(z.im) * :math.cosh(z.re))
    )
  end

  @spec cosh(number()) :: float()
  def cosh(x) when is_number(x), do: :math.cosh(x)

  @spec cosh(Complex.complex()) :: Complex.complex()
  def cosh(z) when is_complex(z) do
    ComplexMath.+(
      :math.cos(z.im) * :math.cosh(z.re),
      ib(:math.sin(z.im) * :math.sinh(z.re))
    )
  end

  @spec tan(number()) :: float()
  def tan(x) when is_number(x), do: :math.tan(x)
  @spec tan(Complex.complex()) :: Complex.complex()
  def tan(z) when is_complex(z), do: ComplexMath./(sin(z), cos(z))

  @spec cot(number()) :: float()
  def cot(x) when is_number(x), do: :math.cos(x) / :math.sin(x)
  @spec cot(Complex.complex()) :: Complex.complex()
  def cot(z) when is_complex(z), do: ComplexMath./(cos(z), sin(z))

  @spec sec(number()) :: float()
  def sec(x) when is_number(x), do: 1 / :math.cos(x)
  @spec sec(Complex.complex()) :: Complex.complex()
  def sec(z) when is_complex(z), do: ComplexMath./(1, cos(z))

  @spec csc(number()) :: float()
  def csc(x) when is_number(x), do: 1 / :math.sin(x)
  @spec csc(Complex.complex()) :: Complex.complex()
  def csc(z) when is_complex(z), do: ComplexMath./(1, sin(z))

  @spec tanh(number()) :: float()
  def tanh(x) when is_number(x), do: :math.tanh(x)
  @spec tanh(Complex.complex()) :: Complex.complex()
  def tanh(z) when is_complex(z), do: ComplexMath./(sinh(z), cosh(z))

  @spec coth(number()) :: float()
  def coth(x) when is_number(x), do: :math.cosh(x) / :math.sinh(x)
  @spec coth(Complex.complex()) :: Complex.complex()
  def coth(z) when is_complex(z), do: ComplexMath./(cosh(z), sinh(z))

  @spec sech(number()) :: float()
  def sech(x) when is_number(x), do: 1 / :math.cosh(x)
  @spec sech(Complex.complex()) :: Complex.complex()
  def sech(z) when is_complex(z), do: ComplexMath./(1, cosh(z))

  @spec csch(number()) :: float()
  def csch(x) when is_number(x), do: 1 / :math.sinh(x)
  @spec csch(Complex.complex()) :: Complex.complex()
  def csch(z) when is_complex(z), do: ComplexMath./(1, sinh(z))
end
