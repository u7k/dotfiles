#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
REPO_DIR="$(dirname "$ROOT_DIR")"
BACKUP_SUFFIX="backup-$(date +%Y%m%d-%H%M%S)"

link_item() {
  local source_path="$1"
  local target_path="$2"

  mkdir -p "$(dirname "$target_path")"

  if [ -L "$target_path" ] && [ "$(readlink "$target_path")" = "$source_path" ]; then
    printf 'already linked: %s\n' "$target_path"
    return
  fi

  if [ -e "$target_path" ] || [ -L "$target_path" ]; then
    local backup_path="${target_path}.${BACKUP_SUFFIX}"
    mv "$target_path" "$backup_path"
    printf 'backed up: %s -> %s\n' "$target_path" "$backup_path"
  fi

  ln -s "$source_path" "$target_path"
  printf 'linked: %s -> %s\n' "$target_path" "$source_path"
}

link_item "$REPO_DIR" "$HOME/.config/dotfiles"
link_item "$ROOT_DIR/config/shell/bash_profile" "$HOME/.bash_profile"
link_item "$ROOT_DIR/config/shell/bashrc" "$HOME/.bashrc"
link_item "$REPO_DIR/shared/shell/profile" "$HOME/.profile"
link_item "$REPO_DIR/shared/shell/zprofile" "$HOME/.zprofile"
link_item "$REPO_DIR/shared/shell/zshenv" "$HOME/.zshenv"
link_item "$ROOT_DIR/config/shell/zshrc" "$HOME/.zshrc"

link_item "$REPO_DIR/shared/config/atuin" "$HOME/.config/atuin"
link_item "$REPO_DIR/shared/config/btop/btop.conf" "$HOME/.config/btop/btop.conf"
link_item "$HOME/.local/state/omarchy/current/theme/btop.theme" "$HOME/.config/btop/themes/current.theme"
link_item "$ROOT_DIR/config/foot" "$HOME/.config/foot"
link_item "$ROOT_DIR/config/ghostty" "$HOME/.config/ghostty"
link_item "$REPO_DIR/shared/config/nvim" "$HOME/.config/nvim"
link_item "$REPO_DIR/shared/config/starship.toml" "$HOME/.config/starship.toml"
link_item "$ROOT_DIR/config/tmux" "$HOME/.config/tmux"
link_item "$REPO_DIR/shared/config/yazi" "$HOME/.config/yazi"
