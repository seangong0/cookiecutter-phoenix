#!/usr/bin/env python

import sys

print("Pre-gen hook is running")
app_name = ":{{ cookiecutter.app_name }}"
assert app_name == app_name.lower(), "'{}' app name should be all lowercase".format(
    app_name
)

use_oban = "{{ cookiecutter.use_oban }}"
use_sqlite = "{{ cookiecutter.use_sqlite }}"
if use_oban == use_sqlite == "y":
    print("\n[ERROR] Oban is not supported with SQLite.")
    print("Oban requires PostgreSQL but you selected SQLite.")
    print(
        "Please re-run cookiecutter and choose 'n' for either 'use_sqlite' or 'use_oban'."
    )
    sys.exit(1)
