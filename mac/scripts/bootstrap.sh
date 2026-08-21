#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"

if [ "$(uname -s)" != "Darwin" ]; then
  printf '%s\n' 'This setup targets macOS.' >&2
  exit 1
fi

"$ROOT_DIR/scripts/install-homebrew.sh"
"$ROOT_DIR/scripts/install-packages.sh"
"$ROOT_DIR/scripts/install-shell-support.sh"
"$ROOT_DIR/scripts/link.sh"
"$ROOT_DIR/scripts/install-terminal-profile.sh"
"$ROOT_DIR/scripts/install-yazi-packages.sh"
"$ROOT_DIR/scripts/install-vscode-extensions.sh"
"$ROOT_DIR/scripts/verify.sh"

printf '\n%s\n' 'Bootstrap complete.'
printf '%s\n' 'Optional next steps:'
printf '%s\n' '  1. Run ./mac/macos/defaults.sh from the repository root if you want the recorded macOS preferences.'
printf '%s\n' '  2. Restart the terminal, then sign in to account-backed applications.'
