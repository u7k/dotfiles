#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
PROFILE_PATH="$ROOT_DIR/config/terminal/TokyoNight.terminal"
PROFILE_NAME="TokyoNight"

if ! defaults read com.apple.Terminal 'Window Settings' 2>/dev/null | grep -q "^[[:space:]]*$PROFILE_NAME ="; then
  open -g "$PROFILE_PATH"

  for _ in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20; do
    if defaults read com.apple.Terminal 'Window Settings' 2>/dev/null | grep -q "^[[:space:]]*$PROFILE_NAME ="; then
      break
    fi
    sleep 0.25
  done
fi

osascript <<'APPLESCRIPT'
tell application "Terminal"
  set font size of settings set "TokyoNight" to 12
  set default settings to settings set "TokyoNight"
  set startup settings to settings set "TokyoNight"

  repeat with terminalWindow in windows
    repeat with terminalTab in tabs of terminalWindow
      set current settings of terminalTab to settings set "TokyoNight"
    end repeat
  end repeat
end tell
APPLESCRIPT
