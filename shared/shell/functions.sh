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

# Pick a file with fzf and preview text with bat when available. Kitty can also
# preview images through its graphics protocol.
# Omarchy defines ff as an alias; remove it before replacing it with the shared
# function so Bash does not expand the alias in the function declaration.
unalias ff eff t 2>/dev/null || true
ff() {
  command -v fzf >/dev/null 2>&1 || {
    printf '%s\n' 'fzf is not installed' >&2
    return 127
  }

  if [ "${TERM:-}" = "xterm-kitty" ] && command -v kitty >/dev/null 2>&1; then
    fzf --preview 'case $(file --mime-type -b -- {}) in image/*) kitty icat --clear --transfer-mode=memory --stdin=no --place=${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}@0x0 -- {} ;; *) bat --style=numbers --color=always -- {} ;; esac' "$@"
  elif command -v bat >/dev/null 2>&1; then
    fzf --preview 'bat --style=numbers --color=always -- {}' "$@"
  else
    fzf "$@"
  fi
}

eff() {
  local file
  file="$(ff)" || return
  [ -n "$file" ] && "${EDITOR:-nvim}" "$file"
}

sff() {
  [ -n "${1:-}" ] || {
    printf '%s\n' 'usage: sff <destination>' >&2
    return 2
  }

  local file
  file="$(find . -type f -print | ff)" || return
  [ -n "$file" ] && scp "$file" "$1"
}

n() {
  if [ "$#" -eq 0 ]; then
    command nvim .
  else
    command nvim "$@"
  fi
}

t() {
  tmux attach 2>/dev/null || tmux new -s Work
}

# Change the current shell directory when leaving Yazi with `q`.
y() {
  local tmp cwd
  tmp="$(mktemp -t yazi-cwd.XXXXXX)" || return
  command yazi "$@" --cwd-file="$tmp"
  cwd="$(command cat -- "$tmp")"
  command rm -f -- "$tmp"
  [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && cd -- "$cwd"
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

copy_to_clipboard() {
  if command -v pbcopy >/dev/null 2>&1; then
    pbcopy
  elif command -v wl-copy >/dev/null 2>&1; then
    wl-copy
  elif command -v xclip >/dev/null 2>&1; then
    xclip -selection clipboard
  else
    printf '%s\n' 'no clipboard command found (pbcopy, wl-copy, or xclip)' >&2
    return 127
  fi
}

copypath() {
  pwd | tr -d '\n' | copy_to_clipboard
}

copyfile() {
  [ -f "${1:-}" ] || { printf '%s\n' 'usage: copyfile <file>' >&2; return 2; }
  copy_to_clipboard < "$1"
}
