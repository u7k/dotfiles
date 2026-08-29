#!/usr/bin/env bash

set -euo pipefail

if ! command -v ya >/dev/null 2>&1; then
  printf '%s\n' 'Yazi is not available yet; skipping flavor installation.'
  exit 0
fi

if [ -d "$HOME/.config/yazi/flavors/tokyo-night.yazi" ]; then
  printf '%s\n' 'Using the version-controlled Tokyo Night Yazi flavor.'
  exit 0
fi

YAZI_CONFIG_HOME="$HOME/.config/yazi" ya pkg install
