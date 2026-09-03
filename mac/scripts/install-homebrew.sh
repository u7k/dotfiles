#!/usr/bin/env bash

set -euo pipefail

if [ "$(uname -m)" = "arm64" ] && [ -x /opt/homebrew/bin/brew ]; then
  printf '%s\n' 'Homebrew is already installed.'
  exit 0
elif [ -x /usr/local/bin/brew ]; then
  printf '%s\n' 'Homebrew is already installed.'
  exit 0
elif command -v brew >/dev/null 2>&1; then
  printf '%s\n' 'Homebrew is already installed.'
  exit 0
fi

if ! xcode-select -p >/dev/null 2>&1; then
  printf '%s\n' 'Requesting Apple Command Line Tools installation...'
  xcode-select --install
  printf '%s\n' 'Finish the Command Line Tools installer, then run bootstrap again.'
  exit 1
fi

printf '%s\n' 'Installing Homebrew...'
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

brew --version
