defimpl String.Chars, for: Complex do
  def to_string(complex) do
    Inspect.Complex.inspect(complex, [])
  end
end

defimpl Inspect, for: Complex do
  def inspect(%Complex{re: re, im: im}, _opts) do
    cond do
      re == 0 and im == 1 ->
        "i"

      re == 0 ->
        "#{im}i"

      im > 0 ->
        "#{re}+#{im}i"

      true ->
        "#{re}#{im}i"
    end
  end
end
