#!/usr/bin/env python

from pathlib import Path
import subprocess


def remove_oban_files():
    oban_migration_path = Path(
        "priv",
        "repo",
        "migrations",
    )
    target_file = oban_migration_path / "20250305072314_add_oban.exs"
    if target_file.exists():
        target_file.unlink()


def remove_mailer_files():
    mailer_file = Path(
        "lib",
        "{{cookiecutter.app_name}}",
        "mailer.ex",
    )
    if mailer_file.exists():
        mailer_file.unlink()


def set_up():
    subprocess.run(["mix", "deps.get"])
    subprocess.run(["mix", "format"])
    subprocess.run(["mix", "ecto.setup"])


def main():
    # 条件删除 Oban 迁移文件
    if "{{cookiecutter.use_oban}}".lower() != "y":
        remove_oban_files()
    if "{{cookiecutter.use_mailer}}".lower() != "y":
        remove_mailer_files()
    if "{{cookiecutter.run_setup}}".lower() == "y":
        set_up()


if __name__ == "__main__":
    main()
