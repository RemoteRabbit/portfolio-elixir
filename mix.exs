defmodule Portfolio.MixProject do
  use Mix.Project

  def project do
    [
      app: :portfolio,
      version: "0.1.0",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      # Docs
      name: "RemoteRabbit Portfolio",
      source_url: "https://github.com/remoterabbit/portfolio-elixir",
      homepage_url: "https://www.remoterabbit.io",
      docs: [
        main: "Portfolio",
        extras: ["README.md"]
      ]
    ]
  end

  def application do
    [
      mod: {Portfolio.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:phoenix, "~> 1.7.7"},
      {:phoenix_html, "~> 3.3"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 0.19.0"},
      {:floki, ">= 0.30.0", only: :test},
      {:phoenix_live_dashboard, "~> 0.8.0"},
      {:esbuild, "~> 0.7", runtime: Mix.env() == :dev},
      {:tailwind, "~> 0.2.0", runtime: Mix.env() == :dev},
      {:swoosh, "~> 1.3"},
      {:finch, "~> 0.13"},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:gettext, "~> 0.20"},
      {:jason, "~> 1.2"},
      {:plug_cowboy, "~> 2.5"},
      {:tentacat, "~> 2.2"},
      {:earmark, "1.4.48"},
      {:yaml_front_matter, "~> 1.0"},
      {:con_cache, "~> 1.0"},
      {:ex_doc, "~> 0.34", only: :dev, runtime: false},
      {:makeup_html, ">= 0.0.0", only: :dev, runtime: false},

      {:httpoison, "~> 2.0"}
    ]
  end

  defp aliases do
    [
      setup: ["deps.get", "assets.setup", "assets.build"],
      server: ["phx.server"],
      "assets.setup": ["tailwind.install --if-missing", "esbuild.install --if-missing"],
      "assets.build": ["tailwind default", "esbuild default"],
      "assets.deploy": ["tailwind default --minify", "esbuild default --minify", "phx.digest"]
    ]
  end
end
