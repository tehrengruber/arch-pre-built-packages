# arch-pre-built-packages

Pre-built Arch Linux packages from the AUR, published as a signed pacman
repository on GitHub Releases. Rebuilt weekly (and on every push to `main`)
by GitHub Actions.

## Currently built

- `gcc13`, `gcc14`
- `python310`, `python311`, `python312`, `python313`
- `yay`
- `claude-code`
- `pingvin-share-x`

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

Then:

```sh
sudo pacman -Sy
sudo pacman -S python312
```

## Releases

- `latest` — always points at the most recent successful build.
- `build-YYYY-MM-DD` — the previous `latest` release is archived under this
  tag (using its original creation date) before a new `latest` is published.