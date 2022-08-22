defmodule Complex.MixProject do
  use Mix.Project

  def project do
    [
      app: :complex,
      version: "1.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      name: "qcomplex",
      source_url: "https://github.com/q60/complex",
      docs: [
        main: "Complex",
        extras: ["README.md"]
      ]
    ]
  end

  defp description() do
    "Elixir library implementing complex numbers and math."
  end

  defp package() do
    [
      name: "qcomplex",
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/q60/complex"
      }
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    []
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.28.4", only: :dev, runtime: false}
    ]
  end
end
