# Uygur's dotfiles

A minimal, repeatable macOS setup for Homebrew, shell tools, editors, and application settings.

## Install

```sh
git clone https://github.com/u7k/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./mac/scripts/bootstrap.sh
```

macOS preferences are intentionally opt-in:

```sh
./mac/macos/defaults.sh
```

## Layout

- `mac/config/` — AeroSpace, terminals, system monitors, editors, and Neovim
- `mac/macos/` — My macOS preferences
- `mac/packages/` — Homebrew bundle
- `mac/scripts/` — install, link, and verification commands

Run `make -C mac help` to see the common commands and `make -C mac verify` to validate the repository.
