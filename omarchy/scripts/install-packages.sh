#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
mapfile -t PACKAGES < <(sed -E '/^[[:space:]]*(#|$)/d' "$ROOT_DIR/packages/pacman.txt")
mapfile -t AUR_PACKAGES < <(sed -E '/^[[:space:]]*(#|$)/d' "$ROOT_DIR/packages/aur.txt")

[ "${#PACKAGES[@]}" -eq 0 ] || omarchy pkg add "${PACKAGES[@]}"
[ "${#AUR_PACKAGES[@]}" -eq 0 ] || omarchy pkg aur add "${AUR_PACKAGES[@]}"
