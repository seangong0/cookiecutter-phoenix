import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :{{ cookiecutter.app_name }}, {{ cookiecutter.app_module }}.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "{{ cookiecutter.app_name }}_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

{% if cookiecutter.use_oban == 'y' -%}
# config Oban
config :{{ cookiecutter.app_name }}, Oban, testing: :manual
{% endif -%}

{% if cookiecutter.use_mailer == 'y' -%}
# config swoosh
config :{{ cookiecutter.app_name }}, {{ cookiecutter.app_module }}.Mailer, adapter: Swoosh.Adapters.Test
{% endif -%}

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :{{ cookiecutter.app_name }}, {{ cookiecutter.app_module }}Web.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "{{ gen_secret(48) }}",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
