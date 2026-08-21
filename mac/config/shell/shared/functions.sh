# Change to the first matching directory below the current directory.
findme() {
  if [ -z "${1:-}" ]; then
    printf '%s\n' 'usage: findme <directory-name>' >&2
    return 2
  fi

  local directory
  directory="$(find . -type d -name "$1" -print -quit 2>/dev/null)"
  if [ -n "$directory" ]; then
    cd "$directory" || return
  else
    printf 'directory not found: %s\n' "$1" >&2
    return 1
  fi
}

# Ask a matching process to stop cleanly. Use killproc9 only when necessary.
killproc() {
  [ -n "${1:-}" ] || { printf '%s\n' 'usage: killproc <pattern>' >&2; return 2; }
  pkill -TERM -f -- "$1"
}

killproc9() {
  [ -n "${1:-}" ] || { printf '%s\n' 'usage: killproc9 <pattern>' >&2; return 2; }
  pkill -KILL -f -- "$1"
}

copypath() {
  pwd | tr -d '\n' | pbcopy
}

copyfile() {
  [ -f "${1:-}" ] || { printf '%s\n' 'usage: copyfile <file>' >&2; return 2; }
  pbcopy < "$1"
}
