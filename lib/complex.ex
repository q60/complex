defmodule Complex do
  @moduledoc """
  Elixir library implementing complex numbers and math.

  The library adds new type of `t:complex/0` numbers and basic math operations for them. Complex numbers can also interact with integers and floats. Actually this library expands existing functions, so they can work with complex numbers too. Number operations available:

  * addition
  * subtraction
  * multiplication
  * division
  * exponentiation
  * absolute value
  * trigonometric functions

  ## Some examples

      iex> use Complex
      Complex

      iex> ~o(1+2i)
      1.0+2.0i

      iex> ~o(1+2i) * ib
      -2.0+1.0i

      iex> Complex.Trig.sin(~o(-11-2i))
      3.762158846210887-0.016051388809949604i

      iex> to_polar(~o(7-9i))
      {11.40175425099138, -0.9097531579442097}

      iex> ~o(1+2i) ** ~o(3+4i)
      0.129009594074467+0.03392409290517014i

  """

  defmacro __using__(_opts) do
    quote do
      import Kernel, except: [-: 1, +: 2, -: 2, *: 2, /: 2, **: 2, abs: 1]
      import ComplexMath

      import Complex,
        only: [is_complex: 1, sigil_o: 2]
    end
  end

  defstruct [:re, :im]

  @type complex() :: %Complex{re: float(), im: float()}
  @typedoc false
  @type operator() :: :+ | :- | :* | :/ | :**

  @doc """
  Returns `true` if `term` is a complex number, otherwise returns `false`.

  Allowed in guard tests.
  """
  defguard is_complex(term) when is_struct(term, Complex)

  @doc """
  Parses a string into a complex number.

  If successful, returns either a `t:complex/0` or `t:float/0`; otherwise returns `:error`.

  ## Examples

      iex> Complex.parse "1+13i"
      1.0+13.0i

      iex> Complex.parse "2.3-1i"
      2.3-1.0i

      iex> Complex.parse "42"
      :error

  """
  @spec parse(String.t()) :: complex() | float() | :error
  def parse(string) do
    case Regex.run(~r/([\+\-]?[0-9\.]+)((?:\+|-)[0-9\.]+)i/, string) do
      [_, re, im] ->
        case Float.parse(im) do
          {0.0, _} ->
            {float, _} = Float.parse(re)
            float

          {im, _} ->
            {re, _} = Float.parse(re)
            %Complex{re: re, im: im}
        end

      _ ->
        :error
    end
  end

  @doc """
  Handles the sigil `~o` for complex numbers.

  It returns a `t:complex/0` or `t:float/0`.

  ## Examples

      iex> ~o(1+4i)
      1.0+4.0i

      iex> ~o(-3.1+5i)
      -3.1+5.0i

  """
  @spec sigil_o(String.t(), list()) :: complex() | float() | :error
  def sigil_o(string, _modifiers), do: parse(string)

  @doc """
  Imaginary unit.

  When no arguments passed, returns imaginary unit; otherwise returns i*b.

  ## Examples

      iex> ib
      i

      iex> ib(-5)
      -5i

  """
  @spec ib(number()) :: %Complex{im: 1, re: number()}
  def ib(b \\ 1), do: %Complex{re: 0, im: b}

  @doc """
  Complex conjugate.

  Returns the complex conjugate of a complex number.

  ## Examples

      iex> conj(~o(5+7i))
      5.0-7.0i

      iex> conj(~o(5-7i))
      5.0+7.0i

  """
  @spec conj(complex()) :: complex()
  def conj(z) when is_complex(z) do
    cond do
      z.im > 0 ->
        %Complex{re: z.re, im: -z.im}

      z.im < 0 ->
        %Complex{re: z.re, im: abs(z.im)}
    end
  end

  @doc """
  Polar coordinates.

  Returns polar coordinates of a complex number as `{radius, angle}`.

  ## Examples

      iex> to_polar(~o(7-9i))
      {11.40175425099138, -0.9097531579442097}

  """
  @spec to_polar(complex()) :: {float, float}
  def to_polar(z) when is_complex(z) do
    a = z.re
    b = z.im
    r = :math.sqrt(a ** 2 + b ** 2)
    theta = :math.atan(b / a)

    {r, theta}
  end

  defp polar_power(z, power) when is_complex(z) do
    {r, theta} = to_polar(z)

    ComplexMath.*(
      r ** power,
      ComplexMath.+(
        :math.cos(power * theta),
        ComplexMath.*(:math.sin(power * theta), ib())
      )
    )
  end

  @doc false
  @spec op(number(), number(), operator()) :: number()
  def op(a, b, op) when is_number(a) and is_number(b) do
    {res, _} =
      [inspect(a), op, inspect(b)]
      |> Enum.join(" ")
      |> Code.eval_string()

    res
  end

  @spec op(number(), complex(), operator()) :: complex() | number()
  def op(a, z, op) when is_number(a) and is_complex(z) do
    case op do
      :+ ->
        %Complex{re: a + z.re, im: z.im}

      :- ->
        %Complex{re: a - z.re, im: z.im}

      :* ->
        %Complex{re: a * z.re, im: a * z.im}

      :/ ->
        z = %Complex{re: a * z.re, im: a * -z.im}
        x = z.re ** 2 + z.im ** 2
        %Complex{re: z.re / x, im: z.im / x}

      :** ->
        ComplexMath.*(
          a ** z.re,
          ComplexMath.+(
            :math.cos(z.im * :math.log(abs(a))),
            ib(:math.sin(z.im * :math.log(abs(a))))
          )
        )
    end
    |> result()
  end

  @spec op(complex(), number(), operator()) :: complex() | number()
  def op(z, b, op) when is_complex(z) and is_number(b) do
    case op do
      :+ ->
        %Complex{re: z.re + b, im: z.im}

      :- ->
        %Complex{re: z.re - b, im: z.im}

      :* ->
        %Complex{re: z.re * b, im: z.im * b}

      :/ ->
        %Complex{re: z.re / b, im: z.im / b}

      :** when not is_float(b) ->
        cond do
          b > 0 ->
            Enum.reduce(1..b, 1, fn _, res ->
              ComplexMath.*(res, z)
            end)

          b < 0 ->
            ComplexMath./(
              1,
              Enum.reduce(1..abs(b), 1, fn _, res ->
                ComplexMath.*(res, z)
              end)
            )

          true ->
            1
        end

      :** ->
        polar_power(z, b)
    end
    |> result()
  end

  @spec op(complex(), complex(), operator()) :: complex() | number()
  def op(z1, z2, op) when is_complex(z1) and is_complex(z2) do
    case op do
      :+ ->
        %Complex{re: z1.re + z2.re, im: z1.im + z2.im}

      :- ->
        %Complex{re: z1.re - z2.re, im: z1.im - z2.im}

      :* ->
        %Complex{
          re: z1.re * z2.re - z1.im * z2.im,
          im: z1.re * z2.im + z1.im * z2.re
        }

      :/ ->
        %Complex{
          re: (z1.re * z2.re + z1.im * z2.im) / (z2.re ** 2 + z2.im ** 2),
          im: (z1.im * z2.re - z1.re * z2.im) / (z2.re ** 2 + z2.im ** 2)
        }

      :** ->
        {r, theta} = to_polar(z1)

        power =
          ComplexMath.+(
            ComplexMath.*(:math.log(r), z2),
            ComplexMath.*(ib(theta), z2)
          )

        ComplexMath.**(:math.exp(1), power)
    end
    |> result()
  end

  @doc false
  @spec op(complex(), :abs) :: number()
  def op(z, :abs) when is_complex(z), do: :math.sqrt(op(z, conj(z), :*))
  @spec op(number(), :abs) :: number()
  def op(a, :abs) when is_number(a), do: abs(a)

  defp result(z) do
    if z.im == 0 do
      z.re
    else
      z
    end
  end
end
