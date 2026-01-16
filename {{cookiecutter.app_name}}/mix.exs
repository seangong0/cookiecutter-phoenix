defmodule {{ cookiecutter.app_module }}.MixProject do
  use Mix.Project

  def project do
    [
      app: :{{ cookiecutter.app_name }},
      version: "{{ cookiecutter.app_version }}",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {{'{'}}{{ cookiecutter.app_module }}.Application, []{{'}'}},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.8"},
      {:phoenix_ecto, "~> 4.7"},
      {:ecto_sql, "~> 3.13"},
      {% if cookiecutter.use_sqlite == 'y' -%}
      {:ecto_sqlite3, "{{ latest_version('ecto_sqlite3') }}"},
      {% else -%}
      {:postgrex, "~> 1.0"},
      {% endif -%}
      {:jason, "~> 1.5"},
      {:dns_cluster, "~> 0.2"},
      {:bandit, "~> 1.10"},
      {:dotenvy, "{{ latest_version('dotenvy') }}"},
      {% if cookiecutter.use_oban == 'y' -%}
      {:oban, "{{ latest_version('oban') }}"},
      {% endif -%}
      {% if cookiecutter.use_mailer == 'y' -%}
      {:swoosh, "{{ latest_version('swoosh') }}"},
      {:gen_smtp, "{{ latest_version('gen_smtp') }}"},
      {% endif -%}
      {% if cookiecutter.use_req == 'y' -%}
      {:req, "{{ latest_version('req') }}"},
      {% endif -%}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end
end
