#!/usr/bin/env bash

# Arrange three or four tiled windows into balanced columns:
# - 3 windows: two windows from the same app are stacked in one column.
# - 4 windows: two columns, each containing two rows.

set -u

AEROSPACE_BIN="$(command -v aerospace 2>/dev/null || true)"
WINDOW_ID="${1:-${AEROSPACE_WINDOW_ID:-}}"

if [ -z "$AEROSPACE_BIN" ] || [ -z "$WINDOW_ID" ]; then
  exit 0
fi

sleep 0.25

WORKSPACE="$($AEROSPACE_BIN list-windows --all --format '%{window-id}|%{workspace}' \
  | awk -F '|' -v id="$WINDOW_ID" '$1 == id { print $2; exit }')"

if [ -z "$WORKSPACE" ]; then
  exit 0
fi

WINDOW_IDS=()
APP_KEYS=()
while IFS='|' read -r id bundle_id app_name; do
  if [ -n "$id" ]; then
    WINDOW_IDS[${#WINDOW_IDS[@]}]="$id"
    if [ -n "$bundle_id" ]; then
      APP_KEYS[${#APP_KEYS[@]}]="$bundle_id"
    else
      APP_KEYS[${#APP_KEYS[@]}]="$app_name"
    fi
  fi
done < <($AEROSPACE_BIN list-windows --workspace "$WORKSPACE" --format '%{window-id}|%{app-bundle-id}|%{app-name}')

WINDOW_COUNT="${#WINDOW_IDS[@]}"
if [ "$WINDOW_COUNT" -ne 3 ] && [ "$WINDOW_COUNT" -ne 4 ]; then
  exit 0
fi

for id in "${WINDOW_IDS[@]}"; do
  $AEROSPACE_BIN layout --window-id "$id" tiling >/dev/null 2>&1 || true
done

$AEROSPACE_BIN flatten-workspace-tree --workspace "$WORKSPACE" >/dev/null 2>&1 || exit 0
$AEROSPACE_BIN layout --workspace "$WORKSPACE" --root h_tiles >/dev/null 2>&1 || exit 0

if [ "$WINDOW_COUNT" -eq 3 ]; then
  PAIR_A=-1
  PAIR_B=-1
  THIRD=-1

  if [ "${APP_KEYS[0]}" = "${APP_KEYS[1]}" ] && [ "${APP_KEYS[0]}" != "${APP_KEYS[2]}" ]; then
    PAIR_A=0
    PAIR_B=1
    THIRD=2
  elif [ "${APP_KEYS[0]}" = "${APP_KEYS[2]}" ] && [ "${APP_KEYS[0]}" != "${APP_KEYS[1]}" ]; then
    PAIR_A=0
    PAIR_B=2
    THIRD=1
  elif [ "${APP_KEYS[1]}" = "${APP_KEYS[2]}" ] && [ "${APP_KEYS[1]}" != "${APP_KEYS[0]}" ]; then
    PAIR_A=1
    PAIR_B=2
    THIRD=0
  fi

  if [ "$PAIR_A" -lt 0 ]; then
    $AEROSPACE_BIN balance-sizes --workspace "$WORKSPACE" >/dev/null 2>&1 || true
    exit 0
  fi

  if [ "$PAIR_A" -eq 0 ] && [ "$PAIR_B" -eq 2 ]; then
    if ! $AEROSPACE_BIN swap --window-id "${WINDOW_IDS[$THIRD]}" left >/dev/null 2>&1; then
      $AEROSPACE_BIN swap --window-id "${WINDOW_IDS[$THIRD]}" right >/dev/null 2>&1 || exit 0
    fi
  fi

  WINDOW_IDS=()
  APP_KEYS=()
  while IFS='|' read -r id bundle_id app_name; do
    WINDOW_IDS[${#WINDOW_IDS[@]}]="$id"
    if [ -n "$bundle_id" ]; then
      APP_KEYS[${#APP_KEYS[@]}]="$bundle_id"
    else
      APP_KEYS[${#APP_KEYS[@]}]="$app_name"
    fi
  done < <($AEROSPACE_BIN list-windows --workspace "$WORKSPACE" --format '%{window-id}|%{app-bundle-id}|%{app-name}')

  if [ "${APP_KEYS[0]}" = "${APP_KEYS[1]}" ]; then
    PAIR_EDGE_ID="${WINDOW_IDS[0]}"
  elif [ "${APP_KEYS[1]}" = "${APP_KEYS[2]}" ]; then
    PAIR_EDGE_ID="${WINDOW_IDS[2]}"
  else
    exit 0
  fi

  if ! $AEROSPACE_BIN join-with --window-id "$PAIR_EDGE_ID" left >/dev/null 2>&1; then
    $AEROSPACE_BIN join-with --window-id "$PAIR_EDGE_ID" right >/dev/null 2>&1 || exit 0
  fi
  $AEROSPACE_BIN layout --window-id "$PAIR_EDGE_ID" v_tiles >/dev/null 2>&1 || exit 0
else
  if ! $AEROSPACE_BIN join-with --window-id "${WINDOW_IDS[0]}" left >/dev/null 2>&1; then
    $AEROSPACE_BIN join-with --window-id "${WINDOW_IDS[0]}" right >/dev/null 2>&1 || exit 0
  fi
  $AEROSPACE_BIN layout --window-id "${WINDOW_IDS[0]}" v_tiles >/dev/null 2>&1 || exit 0

  if ! $AEROSPACE_BIN join-with --window-id "${WINDOW_IDS[3]}" left >/dev/null 2>&1; then
    $AEROSPACE_BIN join-with --window-id "${WINDOW_IDS[3]}" right >/dev/null 2>&1 || exit 0
  fi
  $AEROSPACE_BIN layout --window-id "${WINDOW_IDS[3]}" v_tiles >/dev/null 2>&1 || exit 0
fi

$AEROSPACE_BIN balance-sizes --workspace "$WORKSPACE" >/dev/null 2>&1 || true
