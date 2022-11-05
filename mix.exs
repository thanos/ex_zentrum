defmodule ExZentrum.MixProject do
  use Mix.Project

  @version "0.1.1"

  def project do
    [
      app: :ex_zentrum,
      version: @version,
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
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
      {:geocoder, "~> 1.1"},
      {:ex_doc, "~> 0.29.0", only: :dev, runtime: false},
      {:excoveralls, "~> 0.15.0", only: :test},
      {:jason, "~> 1.4"},
      {:httpoison, "~> 1.8"},
      {:uuid, "~> 1.1"},

      {:dotenv_parser, "~> 2.0"},
      {:mox, "~> 1.0"}


      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
