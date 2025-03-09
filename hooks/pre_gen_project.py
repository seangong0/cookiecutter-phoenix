#!/usr/bin/env python

app_name = ":{{ cookiecutter.app_name }}"
assert app_name == app_name.lower(), "'{}' app name should be all lowercase".format(app_name)