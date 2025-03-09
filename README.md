# Cookiecutter Phoenix

Cookiecutter phoenix app template

## Features

> Todo

## How create
```bash
# 如果需要创建 umbrella 类型的项目请添加参数 --umbrella
mix phx.new awesome_app --no-html \
    --no-assets \
    --no-gettext \
    --no-dashboard \
    --no-live \
    --no-mailer

# 清理 telemetry
rm -rf lib/awesome_app_web/telemetry.ex
sed -i '' '/telemetry/d' mix.exs
sed -i '' '/Telemetry/d' lib/awesoem_app_web/endpoint.ex
sed -i '' '/Telemetry/d' lib/awesoem_app/application.ex

cat <<EOF > awesome_app/.tool-versions
erlang {{cookiecutter.erlang_version}}
elixir {{cookiecutter.elixir_version}}
EOF

find ./awesome_app -depth -name '*awesome_app*' -execdir sh -c 'mv "$1" "$(echo "$1" | sed "s/awesome_app/{{cookiecutter.app_name}}/g")"' _ {} \;

find ./ -type f -exec perl -pi -e 's/AwesomeAppWeb/{{ cookiecutter.app_module }}Web/g' {} +

find ./ -type f -exec perl -pi -e 's/AwesomeApp/{{ cookiecutter.app_module }}/g' {} +
# 再使用 vscode 搜索替换功能检查是否有遗漏

```

注意事项：
```bash
# 类似 mod: {{{{ cookiecutter.app_module }}.Application, []} 可能需要替换为下面的形式
mod: {{'{'}}{{ cookiecutter.app_module }}.Application, []{{'}'}}

# 如果是大段代码，使用下面的形式
{% raw -%}
{:telemetry_poller, measurements: periodic_measurements(), period: 10_000}
{% endraw -%}
```

## 手动测试
```bash
#  请注意您的当前目录下不存在相同的项目名称
rm -rf my_app
cookiecutter ./cookiecutter-phoenix --no-input use_oban=y
```