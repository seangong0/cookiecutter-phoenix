# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :{{ cookiecutter.app_name }},
  ecto_repos: [{{ cookiecutter.app_module }}.Repo],
  generators: [timestamp_type: :utc_datetime_usec]

config :{{ cookiecutter.app_name }}, {{ cookiecutter.app_module }}.Repo,
  migration_primary_key: [name: :id, type: :binary_id],
  migration_foreign_key: [column: :id, type: :binary_id],
  migration_timestamps: [type: :utc_datetime_usec]

{% if cookiecutter.use_oban == 'y' -%}
# config Oban
config :{{ cookiecutter.app_name }}, Oban,
  engine: Oban.Engines.Basic,
  queues: [default: 10],
  repo: {{ cookiecutter.app_module }}.Repo,
  prefix: "oban"
{% endif -%}

{% if cookiecutter.use_mailer == 'y' -%}
config :swoosh, :api_client, false
{% endif -%}

# Configures the endpoint
config :{{ cookiecutter.app_name }}, {{ cookiecutter.app_module }}Web.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: {{ cookiecutter.app_module }}Web.ErrorJSON],
    layout: false
  ],
  pubsub_server: {{ cookiecutter.app_module }}.PubSub,
  live_view: [signing_salt: "{{ gen_secret(8) }}"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
env = config_env()

if "#{env}.exs" |> Path.expand(__DIR__) |> File.exists?() do
  import_config "#{env}.exs"

  if "#{env}.secret.exs" |> Path.expand(__DIR__) |> File.exists?() do
    import_config "#{env}.secret.exs"
  end
end
