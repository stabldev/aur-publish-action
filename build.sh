#!/bin/bash
set -euo pipefail

export HOME=/home/builder
cd "$HOME"

echo "::group::Adding aur.archlinux.org to known hosts"
ssh-keyscan aur.archlinux.org >> ~/.ssh/known_hosts
echo "::endgroup::"

echo "::group::Importing private key"
echo "$INPUT_AUR_SSH_PRIVATE_KEY" > ~/.ssh/id_aur
chmod 600 ~/.ssh/id_aur
echo "::endgroup::"

echo "::group::Generating PKGBUILD"
python /generate-pkgbuild.py
echo "::endgroup::"

echo "::group::Configuring Git"
git config --global user.name "$INPUT_COMMIT_USERNAME"
git config --global user.email "$INPUT_COMMIT_EMAIL"
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
