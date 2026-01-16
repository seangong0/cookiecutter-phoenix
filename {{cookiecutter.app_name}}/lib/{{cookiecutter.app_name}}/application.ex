defmodule {{ cookiecutter.app_module }}.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {{ cookiecutter.app_module }}.Repo,
      {% if cookiecutter.use_sqlite == 'n' and cookiecutter.use_oban == 'y' -%}
      {Oban, Application.fetch_env!(:{{ cookiecutter.app_name }}, Oban)},
      {% endif -%}
      {{ '{' }}DNSCluster, query: Application.get_env(:{{ cookiecutter.app_name }}, :dns_cluster_query) || :ignore{{ '}' }},
      {{ '{' }}Phoenix.PubSub, name: {{ cookiecutter.app_module }}.PubSub{{ '}' }},
      # Start a worker by calling: {{ cookiecutter.app_module }}.Worker.start_link(arg)
      # {{ '{' }}{{ cookiecutter.app_module }}.Worker, arg{{ '{' }},
      # Start to serve requests, typically the last entry
      {{ cookiecutter.app_module }}Web.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: {{ cookiecutter.app_module }}.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    {{ cookiecutter.app_module }}Web.Endpoint.config_change(changed, removed)
    :ok
  end
end
