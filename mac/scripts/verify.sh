#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
FAILED=0

printf '%s\n' 'Checking shell syntax...'
while IFS= read -r file; do
  if ! bash -n "$file"; then
    FAILED=1
  fi
done < <(find "$ROOT_DIR/scripts" "$ROOT_DIR/macos" -type f -name '*.sh' -print | sort)

for file in \
  "$ROOT_DIR/config/shell/bash/bash_profile" \
  "$ROOT_DIR/config/shell/bash/bashrc" \
  "$ROOT_DIR/config/shell/shared/profile" \
  "$ROOT_DIR/config/shell/shared/functions.sh" \
  "$ROOT_DIR/config/shell/shared/path.sh" \
  "$ROOT_DIR/config/shell/shared/tools.sh"; do
  if ! bash -n "$file"; then
    FAILED=1
  fi
done

for file in \
  "$ROOT_DIR/config/shell/shared/aliases" \
  "$ROOT_DIR/config/shell/zsh/p10k.zsh" \
  "$ROOT_DIR/config/shell/zsh/zprofile" \
  "$ROOT_DIR/config/shell/zsh/zshenv" \
  "$ROOT_DIR/config/shell/zsh/zshrc"; do
  if ! zsh -n "$file"; then
    FAILED=1
  fi
done

printf '%s\n' 'Checking package-list syntax...'
if command -v brew >/dev/null 2>&1; then
  if ! HOMEBREW_NO_AUTO_UPDATE=1 brew bundle list --file="$ROOT_DIR/packages/Brewfile" --all >/dev/null; then
    printf '%s\n' 'Homebrew could not parse packages/Brewfile.' >&2
    FAILED=1
  fi
fi

printf '%s\n' 'Checking for duplicate editor extensions...'
for extensions_file in "$ROOT_DIR/config/vscode/vscode-extensions.txt"; do
  DUPLICATES="$(sort "$extensions_file" | uniq -d)"
  if [ -n "$DUPLICATES" ]; then
    printf '%s: duplicate entries\n%s\n' "$extensions_file" "$DUPLICATES" >&2
    FAILED=1
  fi
done

if command -v jq >/dev/null 2>&1; then
  while IFS= read -r json_file; do
    if ! jq empty "$json_file"; then
      FAILED=1
    fi
  done < <(find "$ROOT_DIR/config" -type f -name '*.json' -print | sort)
fi

printf '%s\n' 'Scanning for likely credentials and machine-specific home paths...'
SECRET_PATTERN='(AKIA[0-9A-Z]{16}|gh[oprs]_[A-Za-z0-9_]{20,}|sk-[A-Za-z0-9_-]{20,}|-----BEGIN [A-Z ]*PRIVATE KEY-----|https?://[^/[:space:]@]+:[^/[:space:]@]+@)'
if rg -n --hidden --glob '!.git/**' --glob '!.local/**' "$SECRET_PATTERN" "$ROOT_DIR"; then
  printf '%s\n' 'Potential credential found.' >&2
  FAILED=1
fi

if rg -n --hidden --glob '!.git/**' '/Users/[A-Za-z0-9._-]+' "$ROOT_DIR"; then
  printf '%s\n' 'Absolute macOS home path found.' >&2
  FAILED=1
fi

if [ "$FAILED" -ne 0 ]; then
  printf '%s\n' 'Verification failed.' >&2
  exit 1
fi

printf '%s\n' 'Verification passed.'
