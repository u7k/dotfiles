path_prepend() {
  [ -d "$1" ] || return 0
  case ":$PATH:" in
    *":$1:"*) ;;
    *) PATH="$1:$PATH" ;;
  esac
}

path_append() {
  [ -d "$1" ] || return 0
  case ":$PATH:" in
    *":$1:"*) ;;
    *) PATH="$PATH:$1" ;;
  esac
}

path_prepend "$HOME/.local/bin"
path_prepend "$HOME/.cargo/bin"
[ -n "${HOMEBREW_PREFIX:-}" ] && path_prepend "$HOMEBREW_PREFIX/opt/rustup/bin"
path_append "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

export PATH
