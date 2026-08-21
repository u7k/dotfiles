#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"

if ! command -v brew >/dev/null 2>&1; then
  if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  else
    printf '%s\n' 'Homebrew is not installed. Run scripts/install-homebrew.sh first.' >&2
    exit 1
  fi
fi

brew update
brew bundle --file="$ROOT_DIR/packages/Brewfile"
