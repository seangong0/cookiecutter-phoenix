defmodule {{ cookiecutter.app_module }}.Repo.Migrations.AddOban do
  use Ecto.Migration
  {% if cookiecutter.use_sqlite == 'y' -%}
  def up, do: Oban.Migration.up()

  def down, do: Oban.Migration.down(version: 1)
  {% else -%}
  def up, do: Oban.Migration.up(prefix: "oban")

  def down, do: Oban.Migration.down(prefix: "oban", version: 1)
  {% endif -%}
end
