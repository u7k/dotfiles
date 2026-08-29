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

if command -v atuin >/dev/null 2>&1; then
  if [ -n "${ZSH_VERSION:-}" ]; then
    eval "$(atuin init zsh --disable-up-arrow --disable-ai)"
  elif [ -n "${BASH_VERSION:-}" ]; then
    eval "$(atuin init bash --disable-up-arrow --disable-ai)"
  fi
fi

# Keep zoxide last so its directory-change hook can see the final prompt setup.
# Using `cd` as its command gives Bash and Zsh the same smart-cd behavior.
if command -v zoxide >/dev/null 2>&1; then
  if [ -n "${ZSH_VERSION:-}" ]; then
    eval "$(zoxide init zsh --cmd cd)"
  elif [ -n "${BASH_VERSION:-}" ]; then
    eval "$(zoxide init bash --cmd cd)"
  fi
fi
