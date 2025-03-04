defmodule {{ cookiecutter.app_module }}Web.Router do
  use {{ cookiecutter.app_module }}Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", {{ cookiecutter.app_module }}Web do
    pipe_through :api
  end
end
