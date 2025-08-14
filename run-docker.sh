#!/usr/bin/env bash
# NOTE: this is for testing docker container
set -euo pipefail

# config variables
PKGNAME="aur-test-pkg"
PKGVER="1.0.0"
PKGBUILD="/workspace/pkgbuild-template/PKGBUILD"
AUR_SSH_PRIVATE_KEY="$HOME/.ssh/id_aur"

# 1. build the image
sudo docker build -t aur-publish-action .

# 2. run the container
sudo docker run --rm \
  -e INPUT_PKGNAME="$PKGNAME" \
  -e INPUT_PKGVER="$PKGVER" \
  -e INPUT_PKGBUILD="$PKGBUILD" \
  -e INPUT_AUR_SSH_PRIVATE_KEY="$(cat "$AUR_SSH_PRIVATE_KEY")" \
  -v "$PWD:/workspace" \
  aur-publish-action
