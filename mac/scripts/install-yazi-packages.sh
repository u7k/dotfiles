#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
YAZI_CONFIG_DIR="$ROOT_DIR/config/yazi"

if ! command -v ya >/dev/null 2>&1; then
  printf '%s\n' 'Yazi is not available yet; skipping flavor installation.'
  exit 0
fi

YAZI_CONFIG_HOME="$YAZI_CONFIG_DIR" ya pkg install
