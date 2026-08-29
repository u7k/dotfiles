#!/usr/bin/env bash

set -euo pipefail

if [ ! -d "$HOME/.oh-my-zsh/.git" ]; then
  if [ -e "$HOME/.oh-my-zsh" ]; then
    printf '%s\n' '~/.oh-my-zsh exists but is not a Git checkout; leaving it unchanged.'
  else
    git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
  fi
else
  printf '%s\n' 'Oh My Zsh is already installed.'
fi

if command -v rustup >/dev/null 2>&1; then
  RUSTUP_BIN="$(command -v rustup)"
elif command -v brew >/dev/null 2>&1 && [ -x "$(brew --prefix rustup)/bin/rustup" ]; then
  RUSTUP_BIN="$(brew --prefix rustup)/bin/rustup"
else
  RUSTUP_BIN=""
fi

if [ -n "$RUSTUP_BIN" ] && ! "$RUSTUP_BIN" toolchain list 2>/dev/null | grep -q '^stable'; then
  "$RUSTUP_BIN" default stable
fi
