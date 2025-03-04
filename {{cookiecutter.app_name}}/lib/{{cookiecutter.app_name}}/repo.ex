defmodule {{ cookiecutter.app_module }}.Repo do
  use Ecto.Repo,
    otp_app: :{{ cookiecutter.app_name }},
    adapter: Ecto.Adapters.Postgres
end
