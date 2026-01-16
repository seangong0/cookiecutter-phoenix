#!/usr/bin/env python3
"""
Upgrade dependencies for cookiecutter-phoenix project.

Usage:
    python scripts/upgrade_deps.py          # Check for updates
    python scripts/upgrade_deps.py --update  # Apply updates
"""
import json
import re
import sys
import urllib.request
from pathlib import Path


def parse_mix_exs(mix_exs_path: Path) -> dict:
    """Parse mix.exs and extract dependency versions."""
    content = mix_exs_path.read_text()

    deps = {}

    # Match {:package, "~> x.x"} or {:package, ">= 0.0.0"}
    pattern = r'\{\:?(\w+)\s*,\s*"([^"]+)"'

    for match in re.finditer(pattern, content):
        name, version = match.groups()
        # Skip conditional dependencies and already tracked
        if name not in deps and "{{" not in version and "cookiecutter" not in version:
            deps[name] = version

    return deps


def get_latest_version(name: str) -> str | None:
    """Get the latest major.minor version from Hex."""
    try:
        with urllib.request.urlopen(f"https://hex.pm/api/packages/{name}") as response:
            data = json.loads(response.read().decode())
            version = data["releases"][0]["version"]
            major_minor = ".".join(version.split(".")[:2])
            return f"~> {major_minor}"
    except Exception as e:
        print(f"Error fetching {name}: {e}")
        return None


def normalize_version(version: str) -> tuple:
    """Convert version string to tuple for comparison."""
    # Extract version number
    match = re.search(r"~>\s*([\d.]+)", version)
    if match:
        parts = match.group(1).split(".")
        return tuple(int(p) for p in parts)
    return (0, 0)


def check_updates(deps: dict) -> list:
    """Check for dependency updates."""
    print("Checking for dependency updates...\n")
    updates = []

    for name, current in deps.items():
        latest = get_latest_version(name)
        if latest and normalize_version(latest) > normalize_version(current):
            updates.append((name, current, latest))

    if not updates:
        print("All dependencies are up to date.")
        return []

    print("Updates available:\n")
    for name, current, latest in updates:
        print(f"  {name:15} {current:>12} -> {latest}")

    return updates


def update_mix_exs(mix_exs_path: Path, updates: list):
    """Update mix.exs with new versions."""
    content = mix_exs_path.read_text()
    original = content

    for name, _, latest in updates:
        # Match {:name, "~> x.x"} or {:name, ">= x.x"}
        # Build pattern dynamically
        escaped_name = re.escape(name)
        # Match version pattern
        pattern = r'\{:' + escaped_name + r'\s*,\s*"~> [\d.]+"[^}]*\}'
        pattern2 = r'\{:' + escaped_name + r'\s*,\s*"~> [\d.]+"\}'
        pattern3 = r'\{:' + escaped_name + r'\s*,\s*">= [\d.]+"\s*\}'

        replacement = '{:' + name + ', "' + latest + '"}'

        content = re.sub(pattern, replacement, content)
        content = re.sub(pattern2, replacement, content)
        content = re.sub(pattern3, replacement, content)

    if content != original:
        mix_exs_path.write_text(content)
        print(f"\nUpdated {len(updates)} dependencies in mix.exs")
    else:
        print("\nNo changes made")


def find_mix_exs():
    """Find mix.exs file."""
    candidates = [
        Path(__file__).parent.parent / "{{cookiecutter.app_name}}" / "mix.exs",
        Path(__file__).parent.parent / "mix.exs",
    ]

    for path in candidates:
        if path.exists():
            return path

    print("Error: mix.exs not found")
    sys.exit(1)


def main():
    update = "--update" in sys.argv or "-u" in sys.argv

    mix_exs_path = find_mix_exs()
    deps = parse_mix_exs(mix_exs_path)
    updates = check_updates(deps)

    if updates and update:
        update_mix_exs(mix_exs_path, updates)
        print("\nDone. Remember to commit the changes.")
    elif updates:
        print("\nRun with --update to apply updates.")


if __name__ == "__main__":
    main()
