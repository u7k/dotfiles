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
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool false
defaults write com.apple.finder FXPreferredViewStyle -string "icnv"

# Dock
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock tilesize -int 54
defaults write com.apple.dock show-recents -bool false

# Screenshots
defaults write com.apple.screencapture location -string "$SCREENSHOT_DIR"
defaults write com.apple.screencapture type -string "png"

killall Finder 2>/dev/null || true
killall Dock 2>/dev/null || true
killall SystemUIServer 2>/dev/null || true

printf '%s\n' 'macOS preferences applied.'
