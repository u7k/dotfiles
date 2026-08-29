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
done < <(find "$ROOT_DIR/scripts" -type f -name '*.sh' -print | sort)

for file in \
  "$REPO_DIR/shared/shell/aliases" \
  "$REPO_DIR/shared/shell/functions.sh" \
  "$REPO_DIR/shared/shell/path.sh" \
  "$REPO_DIR/shared/shell/profile" \
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
  "$ROOT_DIR/config/shell/zshrc"; do
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

printf '%s\n' 'Checking package list...'
DUPLICATES="$(sed -E '/^[[:space:]]*(#|$)/d' "$ROOT_DIR/packages/pacman.txt" "$ROOT_DIR/packages/aur.txt" | sort | uniq -d)"
if [ -n "$DUPLICATES" ]; then
  printf 'duplicate Omarchy packages:\n%s\n' "$DUPLICATES" >&2
  FAILED=1
fi

while IFS= read -r package; do
  if ! pacman -Si "$package" >/dev/null 2>&1; then
    printf 'package unavailable: %s\n' "$package" >&2
    FAILED=1
  fi
done < <(sed -E '/^[[:space:]]*(#|$)/d' "$ROOT_DIR/packages/pacman.txt")

# AUR metadata requires network access. Validate installed AUR packages locally
# and leave fresh-install availability to `omarchy pkg aur add`.
while IFS= read -r package; do
  if ! pacman -Q "$package" >/dev/null 2>&1; then
    printf 'AUR package is not installed yet: %s (bootstrap will install it)\n' "$package"
  fi
done < <(sed -E '/^[[:space:]]*(#|$)/d' "$ROOT_DIR/packages/aur.txt")

if command -v jq >/dev/null 2>&1; then
  while IFS= read -r json_file; do
    if ! jq empty "$json_file"; then
      FAILED=1
    fi
  done < <(find "$REPO_DIR/shared/config" -type f -name '*.json' -print | sort)
fi

if [ "$FAILED" -ne 0 ]; then
  printf '%s\n' 'Verification failed.' >&2
  exit 1
fi

printf '%s\n' 'Verification passed.'
