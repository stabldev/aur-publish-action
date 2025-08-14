#!/bin/bash
set -euo pipefail

export HOME=/home/builder
cd "$HOME"

echo "::group::Adding aur.archlinux.org to known hosts"
ssh-keyscan aur.archlinux.org >> ~/.ssh/known_hosts
echo "::endgroup::"

echo "::group::Importing private key"
mkdir -p ~/.ssh
echo "$INPUT_AUR_SSH_PRIVATE_KEY" > ~/.ssh/aur
chmod -vR 600 ~/.ssh/aur*
echo "::endgroup::"

echo "::group::Generating PKGBUILD"
python /generate-pkgbuild.py
echo "::endgroup::"

echo "::group::Configuring Git"
git config --global user.name "github-actions[bot]"
git config --global user.email "41898282+github-actions[bot]@users.noreply.github.com"
echo "::endgroup::"

echo "::group::Cloning AUR repo"
git clone ssh://aur@aur.archlinux.org/${INPUT_PKGNAME}.git aur-repo
cp ./pkgbuild/${INPUT_PKGNAME}/PKGBUILD aur-repo/
cd aur-repo
echo "::endgroup::"

echo "::group::Updating checksums"
updpkgsums
echo "::endgroup::"

echo "::group::Generating .SRCINFO"
makepkg --printsrcinfo > .SRCINFO
echo "::endgroup::"

echo "::group::Git commit & push"
git add PKGBUILD .SRCINFO
git commit -m "chore: release $(grep pkgver PKGBUILD | cut -d= -f2)"
git push origin master
echo "::endgroup::"
