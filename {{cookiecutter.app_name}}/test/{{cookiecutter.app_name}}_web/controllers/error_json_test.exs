defmodule {{ cookiecutter.app_module }}Web.ErrorJSONTest do
  use {{ cookiecutter.app_module }}Web.ConnCase, async: true

  test "renders 404" do
    assert {{ cookiecutter.app_module }}Web.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert {{ cookiecutter.app_module }}Web.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
