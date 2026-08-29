#!/usr/bin/env bash

set -euo pipefail

ZSH_PATH="$(command -v zsh)"
CURRENT_SHELL="$(getent passwd "$USER" | cut -d: -f7)"

if [ "$CURRENT_SHELL" = "$ZSH_PATH" ]; then
  printf 'Zsh is already the default shell: %s\n' "$ZSH_PATH"
  exit 0
fi

if ! grep -Fxq "$ZSH_PATH" /etc/shells; then
  printf '%s is not listed in /etc/shells. Add it before changing shells.\n' "$ZSH_PATH" >&2
  exit 1
fi

chsh -s "$ZSH_PATH"
printf 'Default shell changed to %s; it takes effect at the next login.\n' "$ZSH_PATH"
