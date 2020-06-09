defmodule Fxnk.MixProject do
  use Mix.Project

  def project do
    [
      app: :fxnk,
      version: "0.1.1",
      elixir: "~> 1.10",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      # Docs
      name: "Fxnk",
      source_url: "https://github.com/matthewsecrist/fxnk",
      homepage_url: "https://github.com/matthewsecrist/fxnk",
      docs: [
        main: "Fxnk",
        logo: "fx.png",
        extras: ["README.md"]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.4", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.22", only: :dev, runtime: false},
      {:mix_test_watch, "~> 1.0", only: :dev, runtime: false}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end

  defp description do
    "A functional programming helper library inspired by Ramda."
  end

  defp package() do
    [
      # This option is only needed when you don't want to use the OTP application name
      name: "fxnk",
      # These are the default files included in the package
      files: ~w(lib .formatter.exs mix.exs README* LICENSE*),
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/matthewsecrist/fxnk"}
    ]
  end
end
