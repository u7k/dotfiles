#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
EXTENSIONS_FILE="$ROOT_DIR/config/vscode/vscode-extensions.txt"

if ! command -v code >/dev/null 2>&1; then
  CODE_BIN="/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
  if [ -x "$CODE_BIN" ]; then
    export PATH="$(dirname "$CODE_BIN"):$PATH"
  else
    printf '%s\n' 'VS Code is not available yet; skipping extension installation.'
    exit 0
  fi
fi

while IFS= read -r extension; do
  [ -n "$extension" ] || continue
  code --install-extension "$extension" --force
done < "$EXTENSIONS_FILE"
