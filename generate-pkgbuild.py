#! /usr/bin/env python3
from os import environ
from pathlib import Path

pkgname = environ.get("INPUT_PKGNAME")
pkgver = environ.get("INPUT_PKGVER")
pkgbuild_template = environ.get("INPUT_PKGBUILD_TEMPLATE")

if not pkgname or not pkgver or not pkgbuild_template:
    print("::error::Missing required inputs")
    exit(1)

template_path = Path(pkgbuild_template)
if not template_path.is_absolute():
    workspace = Path(environ.get("GITHUB_WORKSPACE", "/github/workspace"))
    template_path = workspace / template_path

if not template_path.exists():
    print(f"::error::PKGBUILD template file not found: {template_path}")
    exit(1)

template_content = template_path.read_text()

output_dir = Path(f"./pkgbuild/{pkgname}")
output_dir.mkdir(parents=True, exist_ok=True)

maintainer = ""
body = ""

for line in template_content.splitlines(True):
    if line.startswith("#"):
        if "Maintainer" in line:
            maintainer = line
        continue
    body += line

dynamic_fields = f"pkgname={pkgname}\n"
dynamic_fields += f"pkgver={pkgver}\n"

content = maintainer + "\n" + dynamic_fields + body.lstrip("\n")
(output_dir / "PKGBUILD").write_text(content)  # pyright: ignore[reportUnusedCallResult]
