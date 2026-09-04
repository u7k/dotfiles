#!/usr/bin/env bash

set -euo pipefail

if [ "$(uname -s)" != "Darwin" ]; then
  printf '%s\n' 'This script targets macOS.' >&2
  exit 1
fi

SCREENSHOT_DIR="$HOME/screenshots"
mkdir -p "$SCREENSHOT_DIR"

# Use the traditional scroll direction.
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# Finder
# Show hidden files and folders.
defaults write com.apple.finder AppleShowAllFiles -bool true
# Show filename extensions for all files.
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# Keep folders before files when sorting.
defaults write com.apple.finder _FXSortFoldersFirst -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool false
defaults write com.apple.finder FXPreferredViewStyle -string "icnv"

# Dock
# Show only applications that are currently running.
defaults write com.apple.dock static-only -bool true
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock tilesize -int 54
defaults write com.apple.dock show-recents -bool false

# Screenshots
defaults write com.apple.screencapture location -string "$SCREENSHOT_DIR"
defaults write com.apple.screencapture type -string "png"

# Kill affected applications.
APPS=(
  Finder
  Dock
  SystemUIServer
)

for APP in "${APPS[@]}"; do
  killall "$APP" &>/dev/null || true
done

printf '%s\n' 'macOS preferences applied.'
