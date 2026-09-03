#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
REPO_DIR="$(dirname "$ROOT_DIR")"
FAILED=0

printf '%s\n' 'Checking shell syntax...'
while IFS= read -r file; do
  if ! bash -n "$file"; then
    FAILED=1
  fi
done < <(find "$ROOT_DIR/scripts" "$ROOT_DIR/macos" "$REPO_DIR/shared/scripts" -type f -name '*.sh' -print | sort)

for file in \
  "$ROOT_DIR/config/shell/bash/bash_profile" \
  "$ROOT_DIR/config/shell/bash/bashrc" \
  "$REPO_DIR/shared/shell/profile" \
  "$REPO_DIR/shared/shell/functions.sh" \
  "$REPO_DIR/shared/shell/path.sh" \
  "$REPO_DIR/shared/shell/tools.sh"; do
  if ! bash -n "$file"; then
    FAILED=1
  fi
done

for file in \
  "$REPO_DIR/shared/shell/aliases" \
  "$REPO_DIR/shared/shell/zprofile" \
  "$REPO_DIR/shared/shell/zshenv" \
  "$REPO_DIR/shared/shell/zshrc" \
  "$REPO_DIR/shared/shell/omarchy-portable.zsh" \
  "$ROOT_DIR/config/shell/zsh/zshrc"; do
  if ! zsh -n "$file"; then
    FAILED=1
  fi
done

if command -v starship >/dev/null 2>&1; then
  if ! STARSHIP_CACHE="${TMPDIR:-/tmp}/starship-cache" \
    STARSHIP_CONFIG="$REPO_DIR/shared/config/starship.toml" starship print-config >/dev/null; then
    printf '%s\n' 'Starship configuration is invalid.' >&2
    FAILED=1
  fi
fi

printf '%s\n' 'Checking package-list syntax...'
if [ "$(uname -m)" = "arm64" ] && [ -x /opt/homebrew/bin/brew ]; then
  BREW_BIN=/opt/homebrew/bin/brew
elif [ -x /usr/local/bin/brew ]; then
  BREW_BIN=/usr/local/bin/brew
else
  BREW_BIN="$(command -v brew 2>/dev/null || true)"
fi

if [ -n "$BREW_BIN" ]; then
  if ! HOMEBREW_NO_AUTO_UPDATE=1 "$BREW_BIN" bundle list --file="$ROOT_DIR/packages/Brewfile" --all >/dev/null; then
    printf '%s\n' 'Homebrew could not parse packages/Brewfile.' >&2
    FAILED=1
  fi
fi
unset BREW_BIN

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
  done < <(find "$ROOT_DIR/config" "$REPO_DIR/shared/config" -type f -name '*.json' -print | sort)
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
