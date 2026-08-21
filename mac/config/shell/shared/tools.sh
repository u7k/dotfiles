if command -v mise >/dev/null 2>&1; then
  if [ -n "${ZSH_VERSION:-}" ]; then
    eval "$(mise activate zsh)"
  elif [ -n "${BASH_VERSION:-}" ]; then
    eval "$(mise activate bash)"
  fi
fi

if command -v thefuck >/dev/null 2>&1; then
  THEFUCK_ALIAS="$(thefuck --alias 2>/dev/null || true)"
  [ -n "$THEFUCK_ALIAS" ] && eval "$THEFUCK_ALIAS"
  unset THEFUCK_ALIAS
fi
