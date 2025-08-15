# aur-publish-action
GitHub Action that generates a `PKGBUILD` from a template and publishes it to the [AUR](https://aur.archlinux.org/).

## Inputs

- **`pkgname`** (*required*) - AUR package name.
- **`pkgver`** (*required*) - AUR package version.
- **`pkgbuild_template`** (*optional*, default: `./pkgbuild-template/PKGBUILD`) - Path to `PKGBUILD` template.
- **`commit_username`** (*optional*, default: `github-actions[bot]`) - The username to use when creating new commit.
- **`commit_email`** (*optional*, default: `41898282+github-actions[bot]@users.noreply.github.com`) - The email to use when creating new commit.
- **`aur_ssh_private_key`** (*required*) - Your private key with access to AUR package.

## PKGBUILD Template Example

Place your `PKGBUILD` template in a directory (default: `pkgbuild-template`) and let the action fill in `pkgname`, `pkgver`, and `sha256sums` automatically. Example:

```bash
# Maintainer: stabldev <thestabldev@gmail.com>
# This is not a full PKGBUILD
# pkgname, pkgver, and sha256sums are to be generated

pkgrel=1
pkgdesc="Empty test package"
arch=("any")
license=("MIT")
source=("https://github.githubassets.com/favicons/favicon.png")
sha256sums=()

package() {
  install -Dm644 "$srcdir/favicon.png" "$pkgdir/usr/share/$pkgname/favicon.png"
}
```

## Example Usage

Create a workflow `.github/workflows/publish.yml`:

```yaml
name: Publish AUR Package

on:
  push:
    tags:
      - '*'

jobs:
  aur-publish:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Publish to AUR
        uses: stabldev/aur-publish-action@v1
        with:
          pkgname: my-awesome-package
          pkgver: ${{ github.ref_name }}
          aur_ssh_private_key: ${{ secrets.AUR_SSH_PRIVATE_KEY }}
```

**Tip:** To create secrets (such as `secrets.AUR_USERNAME`, `secrets.AUR_EMAIL`, and `secrets.AUR_SSH_PRIVATE_KEY` above), go to `$YOUR_GITHUB_REPO_URL/settings/secrets`.  
[Read this for more information](https://help.github.com/en/actions/configuring-and-managing-workflows/creating-and-storing-encrypted-secrets).

## Acknowledgements

This action was inspired by [KSXGitHub/github-actions-deploy-aur](https://github.com/KSXGitHub/github-actions-deploy-aur).  
Unlike that project, this action adds automatic `PKGBUILD` generation and checksum updates.
