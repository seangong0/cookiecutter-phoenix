#!/usr/bin/env python3
from jinja2.ext import Extension
import secrets
import urllib.request
import json

deps_default_versions = {
    'oban': "2.19",
}

def latest_package_version(name: str) -> str:
    try:
        with urllib.request.urlopen(f"https://hex.pm/api/packages/{name}") as response:
            data = json.loads(response.read().decode())
            version = data['releases'][0]['version']
            major_minor = '.'.join(version.split('.')[:2])
            return f"~> {major_minor}"
    except Exception as e:
        print(f"Error fetching {name} version: {e}")
        return deps_default_versions[name]


class CustomExtension(Extension):
    def __init__(self, environment):
        super(CustomExtension, self).__init__(environment)
        environment.globals['gen_secret'] = lambda v: secrets.token_urlsafe(v)
        environment.globals['latest_version'] = latest_package_version