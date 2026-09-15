# Uygur's dotfiles

A repeatable macOS and Omarchy setup with Ghostty, Zsh, Oh My Zsh, and a
Warp-inspired Starship prompt shared across both platforms.

## Install

### macOS

```sh
git clone https://github.com/u7k/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./mac/scripts/bootstrap.sh
```

macOS preferences are intentionally opt-in:

```sh
./mac/macos/defaults.sh
```

### Omarchy

```sh
git clone https://github.com/u7k/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./omarchy/scripts/bootstrap.sh
```

## Layout

- `shared/` — shell aliases/functions plus portable TUI and terminal configs
- `mac/config/` — macOS shell, OmniWM, Vicinae, Ghostty, VS Code, and platform wrappers
- `mac/macos/` — My macOS preferences
- `mac/packages/` — Homebrew bundle
- `mac/scripts/` — install, link, and verification commands
- `omarchy/config/` — Omarchy Bash, Foot, Ghostty, and tmux integration wrappers
- `omarchy/packages/` — Arch package list for the shared terminal workflow
- `omarchy/scripts/` — install, link, and verification commands

Run `make -C mac help` or `make -C omarchy help` for platform commands.

The Omarchy bootstrap installs packages through `omarchy pkg` (official Arch
repositories plus AUR), keeps the original Omarchy aliases/functions available
from Zsh, and changes the account's default shell to Zsh. The macOS bootstrap
uses the Brewfile. Lumen is installed by both package flows.
