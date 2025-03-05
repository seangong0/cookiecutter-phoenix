#!/bin/bash

SECRET_KEY_BASE=$(openssl rand -base64 64 | tr -d '\n=' | tr '+/' '-_')
escaped_secret=$(printf "%s" "$SECRET_KEY_BASE" | sed -e 's/[\/&]/\\&/g')

sed -i '' "s#SECRET_KEY_BASE#$escaped_secret#g" config/dev.exs

SIGNING_SALT=$(openssl rand -hex 4)
LIVE_VIEW_SIGNING_SALT=$(openssl rand -hex 4)
sed -i '' "s/SIGNING_SALT/$SIGNING_SALT/g" lib/{{cookiecutter.app_name}}_web/endpoint.ex
sed -i '' "s/LIVE_VIEW_SIGNING_SALT/$LIVE_VIEW_SIGNING_SALT/g" config/config.exs

mix deps.get
# setup oban
if [ "{{cookiecutter.use_oban}}" = "y" ]; then
    yes | mix oban.install 
fi
mix ecto.setup
mix format
