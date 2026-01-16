defmodule {{ cookiecutter.app_module }}.Repo do
  use Ecto.Repo,
    otp_app: :{{ cookiecutter.app_name }},
    {% if cookiecutter.use_sqlite == 'y' -%}
    adapter: Ecto.Adapters.SQLite3
    {% else -%}
    adapter: Ecto.Adapters.Postgres
    {% endif -%}
end
