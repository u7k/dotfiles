#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"

if [ "$(uname -s)" != "Linux" ] || ! command -v omarchy >/dev/null 2>&1; then
  printf '%s\n' 'This setup targets an installed Omarchy system.' >&2
  exit 1
fi

"$ROOT_DIR/scripts/install-packages.sh"
"$ROOT_DIR/scripts/install-shell-support.sh"
"$ROOT_DIR/scripts/link.sh"
"$ROOT_DIR/scripts/set-default-shell.sh"
"$ROOT_DIR/scripts/install-yazi-packages.sh"
"$ROOT_DIR/scripts/verify.sh"

printf '\n%s\n' 'Omarchy bootstrap complete. Restart the terminal to load the shared shell setup.'
