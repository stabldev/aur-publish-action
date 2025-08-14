#! /usr/bin/env python3
from os import environ
from pathlib import Path

pkgname = environ.get("INPUT_PKGNAME")
pkgver = environ.get("INPUT_PKGVER")
pkgbuild_dir = environ.get("INPUT_PKGBUILD_DIR")

if not pkgname or not pkgver or not pkgbuild_dir:
    print("::error::Missing required inputs")
    exit(1)

output_dir = Path(f"./pkgbuild/{pkgname}")
output_dir.mkdir(parents=True, exist_ok=True)

template_path = Path(pkgbuild_dir) / "PKGBUILD"
template_content = template_path.read_text()

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

content = maintainer + "\n" + dynamic_fields + body.replace("\n", "", 1)
(output_dir / "PKGBUILD").write_text(
    content
)  # pyright: ignore[reportUnusedCallResult]
