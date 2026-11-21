#!/bin/bash
#
# Bump PKGBUILD to an upstream release.
#
#   ./update.sh [version]      # default: the latest release
#
# Must leave PKGBUILD untouched when it is already at that version. This
# skeleton fits a GitHub release; set repo and adapt the checksum update.
#
set -euo pipefail

repo=OWNER/REPO

here=$(cd "$(dirname "$0")" && pwd)
pkgbuild=$here/PKGBUILD

version=${1:-}
if [[ -z $version ]]; then
    version=$(curl -sSf "https://api.github.com/repos/$repo/releases/latest" |
              python3 -c 'import json,sys; print(json.load(sys.stdin)["tag_name"].lstrip("v"))')
fi

current=$(sed -n 's/^pkgver=//p' "$pkgbuild")
if [[ $current == "$version" ]]; then
    printf 'already at %s\n' "$version"
    exit 0
fi

sed -i -e "s/^pkgver=.*/pkgver=$version/" \
       -e "s/^pkgrel=.*/pkgrel=1/" \
       "$pkgbuild"
# TODO: update the checksums, e.g. from the release asset digests
# (see tehrengruber/victoriametrics-pkg's update.sh).

printf '%s -> %s\n' "$current" "$version"
