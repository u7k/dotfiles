#!/usr/bin/env bash

set -euo pipefail

SHARED_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
DEFAULTS_FILE="$SHARED_DIR/config/codex/config.toml"
CODEX_CONFIG_DIR="${CODEX_HOME:-$HOME/.codex}"
TARGET_FILE="$CODEX_CONFIG_DIR/config.toml"

mkdir -p "$CODEX_CONFIG_DIR"

if [ ! -e "$TARGET_FILE" ]; then
  install -m 600 "$DEFAULTS_FILE" "$TARGET_FILE"
  printf 'Installed Codex defaults at %s\n' "$TARGET_FILE"
  exit 0
fi

TEMP_FILE="$(mktemp "$CODEX_CONFIG_DIR/config.toml.tmp.XXXXXX")"
trap 'rm -f "$TEMP_FILE"' EXIT

awk '
  NR == FNR {
    if ($0 ~ /^[[:space:]]*[A-Za-z0-9_.-]+[[:space:]]*=/) {
      key = $0
      sub(/^[[:space:]]*/, "", key)
      sub(/[[:space:]]*=.*$/, "", key)
      defaults[key] = $0
      order[++count] = key
    }
    next
  }

  function print_missing(    i, key) {
    for (i = 1; i <= count; i++) {
      key = order[i]
      if (!seen[key]) {
        print defaults[key]
        seen[key] = 1
      }
    }
  }

  !in_table && $0 ~ /^[[:space:]]*$/ {
    pending_blanks = pending_blanks $0 ORS
    next
  }

  !in_table && $0 ~ /^\[/ {
    print_missing()
    printf "%s", pending_blanks
    pending_blanks = ""
    in_table = 1
  }

  !in_table && $0 ~ /^[[:space:]]*[A-Za-z0-9_.-]+[[:space:]]*=/ {
    printf "%s", pending_blanks
    pending_blanks = ""
    key = $0
    sub(/^[[:space:]]*/, "", key)
    sub(/[[:space:]]*=.*$/, "", key)
    if (key in defaults) {
      print defaults[key]
      seen[key] = 1
      next
    }
  }

  { print }

  END {
    if (!in_table) {
      print_missing()
      printf "%s", pending_blanks
    }
  }
' "$DEFAULTS_FILE" "$TARGET_FILE" > "$TEMP_FILE"

if cmp -s "$TARGET_FILE" "$TEMP_FILE"; then
  printf '%s\n' 'Codex defaults are already configured.'
  exit 0
fi

BACKUP_FILE="$(mktemp "$TARGET_FILE.bak.XXXXXXXX")"
cp -p "$TARGET_FILE" "$BACKUP_FILE"
install -m 600 "$TEMP_FILE" "$TARGET_FILE"
printf 'Updated Codex defaults; previous config saved at %s\n' "$BACKUP_FILE"
