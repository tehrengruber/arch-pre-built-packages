# arch-pre-built-packages

Pre-built Arch Linux packages from the AUR, published as a signed pacman
repository on GitHub Releases. Rebuilt weekly (and on every push to `main`)
by GitHub Actions.

## Currently built

x86_64 and aarch64:

- `claude-code`

x86_64 only:

- `python310`, `python311`, `python312`, `python313`
- `yay`
- `mutagen.io-bin`
- `codebase-memory-mcp`
- `pingvin-share-x`
- `victoriametrics`, `vmutils`
- `dex-idp`

Architecture-independent (in both databases):

- `python-synapse-auto-dm`

The architectures are configured per package via the `arch` field in
[`.github/packages.yml`](.github/packages.yml). aarch64 packages are built on
native GitHub ARM runners inside an Arch Linux ARM container.

## Using the repository

Import the signing key:

```sh
sudo curl -L -o /etc/pacman.d/arch-pre-built.gpg \
    https://github.com/tehrengruber/arch-pre-built-packages/releases/download/latest/arch-pre-built.gpg
sudo pacman-key --add /etc/pacman.d/arch-pre-built.gpg
sudo pacman-key --lsign-key till@ehrengruber.ch
```

Add to `/etc/pacman.conf`:

```ini
[arch-pre-built]
Server = https://github.com/tehrengruber/arch-pre-built-packages/releases/download/latest
```

On aarch64 (Arch Linux ARM) use the `arch-pre-built-aarch64` database instead:

```ini
[arch-pre-built-aarch64]
Server = https://github.com/tehrengruber/arch-pre-built-packages/releases/download/latest
```

Then:

```sh
sudo pacman -Sy
sudo pacman -S python312
```

## Releases

- `latest` — always points at the most recent successful build.
- `build-YYYY-MM-DD` — the previous `latest` release is archived under this
  tag (using its original creation date) before a new `latest` is published.

## PKGBUILD repos that update themselves

For a package maintained in its own repository (PKGBUILD at the root), two
reusable workflows keep it current without manual work:

- [`pkg-repo-update.yml`](.github/workflows/pkg-repo-update.yml) runs the
  repo's `update.sh` daily and opens a pull request when it bumps `pkgver`,
  with auto-merge queued behind the build check.
- [`pkg-repo-build.yml`](.github/workflows/pkg-repo-build.yml) builds the
  package on pull requests and pushes, natively for every architecture in the
  PKGBUILD's `arch=()` (x86_64, aarch64 or any; override with the `archs`
  input), optionally checking that it contains the expected files.

To set up a new package repo:

1. Copy [`templates/pkg-repo/`](templates/pkg-repo) into it, then adapt
   `update.sh` and the `with:` inputs of both workflows.
2. Add an `UPDATE_PAT` secret: a fine-grained token for that repo with
   *Contents* and *Pull requests* read/write. A pull request opened with
   `GITHUB_TOKEN` would not trigger the build check.
3. Enable *Allow auto-merge* and protect `main`, requiring the
   `build / build` status check.
4. Add the repo to [`.github/packages.yml`](.github/packages.yml) so it is
   published here.

