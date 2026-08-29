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
