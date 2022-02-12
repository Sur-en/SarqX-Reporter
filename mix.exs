defmodule SarqXReporter.MixProject do
  use Mix.Project

  def project do
    [
      app: :sarqx_reporter,
      version: "0.1.0",
      elixir: "~> 1.13",
      compilers: Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      escript: escript(),
      deps: deps(),
      dialyzer: [plt_add_deps: :apps_direct, plt_add_apps: [:sarqx_reporter]],
      aliases: aliases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {SarqXReporter.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:websockex, "~> 0.4.2"},
      {:jason, "~> 1.0"},
      {:httpoison, "~> 1.8.0"},
      {:plug_crypto, "~> 1.2.0"},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false}
    ]
  end

  defp escript do
    [main_module: SarqXReporter.CLI, name: "sarqx-reporter"]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  #
  # Aliases listed here are available only for this project
  # and cannot be accessed from applications inside the apps/ folder.
  defp aliases do
    [
      setup: ["cmd mix setup"],
      eb: ["cmd mix escript.build"],
      br: ["cmd mix escript.build && ./sarqx_reporter --help"]
    ]
  end
end
