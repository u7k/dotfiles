#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
REPO_DIR="$(dirname "$ROOT_DIR")"
BACKUP_SUFFIX="backup-$(date +%Y%m%d-%H%M%S)"

link_item() {
  local source_path="$1"
  local target_path="$2"

  if [ "$source_path" = "$target_path" ]; then
    printf 'already in place: %s\n' "$target_path"
    return 0
  fi

  mkdir -p "$(dirname "$target_path")"

  if [ -L "$target_path" ] && [ "$(readlink "$target_path")" = "$source_path" ]; then
    printf 'already linked: %s\n' "$target_path"
    return 0
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

link_item "$REPO_DIR/shared/shell/profile" "$HOME/.profile"
link_item "$REPO_DIR/shared/shell/hushlogin" "$HOME/.hushlogin"
link_item "$REPO_DIR/shared/shell/zprofile" "$HOME/.zprofile"
link_item "$REPO_DIR/shared/shell/zshenv" "$HOME/.zshenv"
link_item "$ROOT_DIR/config/shell/zsh/zshrc" "$HOME/.zshrc"
link_item "$ROOT_DIR/config/shell/bash/bash_profile" "$HOME/.bash_profile"
link_item "$ROOT_DIR/config/shell/bash/bashrc" "$HOME/.bashrc"

link_item "$ROOT_DIR/config/aerospace/aerospace.toml" "$HOME/.aerospace.toml"
link_item "$ROOT_DIR/config/aerospace" "$HOME/.config/aerospace"
link_item "$REPO_DIR/shared/config/atuin" "$HOME/.config/atuin"
link_item "$REPO_DIR/shared/config/btop" "$HOME/.config/btop"
link_item "$ROOT_DIR/config/ghostty" "$HOME/.config/ghostty"
link_item "$ROOT_DIR/config/nano/nanorc" "$HOME/.nanorc"
link_item "$REPO_DIR/shared/config/nvim" "$HOME/.config/nvim"
link_item "$REPO_DIR/shared/config/starship.toml" "$HOME/.config/starship.toml"
link_item "$REPO_DIR/shared/config/tmux" "$HOME/.config/tmux"
link_item "$REPO_DIR/shared/config/yazi" "$HOME/.config/yazi"

link_item "$ROOT_DIR/config/vscode/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"
