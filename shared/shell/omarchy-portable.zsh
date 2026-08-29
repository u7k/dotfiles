# Portable helpers derived from Omarchy's interactive shell defaults.
# This file is intentionally loaded only on macOS: Omarchy already provides
# these functions through $OMARCHY_PATH/default/bash/functions.

# Compression
compress() {
  [[ -n "${1:-}" ]] || {
    print -u2 'usage: compress <path>'
    return 2
  }
  tar -czf "${1%/}.tar.gz" "${1%/}"
}

decompress() {
  [[ -n "${1:-}" ]] || {
    print -u2 'usage: decompress <archive.tar.gz>'
    return 2
  }
  tar -xzf "$1"
}

# SSH local port forwarding
fip() {
  (( $# >= 2 )) || {
    print -u2 'usage: fip <host> <port1> [port2] ...'
    return 2
  }

  local host="$1" port
  shift
  for port in "$@"; do
    command ssh -f -N -L "${port}:localhost:${port}" "$host" &&
      print "Forwarding localhost:$port -> $host:$port"
  done
}

dip() {
  (( $# > 0 )) || {
    print -u2 'usage: dip <port1> [port2] ...'
    return 2
  }

  local port
  for port in "$@"; do
    if pkill -f "ssh.*-L ${port}:localhost:${port}"; then
      print "Stopped forwarding port $port"
    else
      print "No forwarding on port $port"
    fi
  done
}

lip() {
  pgrep -fl 'ssh.*-L [0-9]+:localhost:[0-9]+' || print 'No active forwards'
}

# Clean up terminal modes after SSH exits and reconnect a dropped interactive
# session. Fast authentication/connection failures are returned immediately.
ssh() {
  local rc started

  started=$SECONDS
  command ssh "$@"
  rc=$?

  [[ -t 1 ]] || return $rc
  _ssh_disarm

  if (( rc != 255 )) || [[ ! -t 0 ]] || ! _ssh_interactive "$@" ||
    (( SECONDS - started < 30 )); then
    return $rc
  fi

  (
    while true; do
      print 'Connection lost. Reconnecting (Ctrl-C to stop)...'
      sleep 2
      command ssh "$@"
      rc=$?
      _ssh_disarm
      (( rc != 255 )) && exit $rc
    done
  )
}

_ssh_disarm() {
  printf '\e[?1000l\e[?1002l\e[?1003l\e[?1006l\e[?1004l\e[?1049l\e[?25h'
}

_ssh_interactive() {
  local value_opts='BbcDEeFIiJLlmOoPpQRSWw'
  local argv=("$@") arg letters i dest='' opts_done=''

  while (( $# )); do
    arg="$1"
    shift

    if [[ -z "$opts_done" && "$arg" == '--' ]]; then
      opts_done=1
    elif [[ -z "$opts_done" && "$arg" == -?* ]]; then
      letters="${arg#-}"
      for (( i = 0; i < ${#letters}; i++ )); do
        if [[ "$value_opts" == *"${letters:i:1}"* ]]; then
          (( i == ${#letters} - 1 )) && shift
          break
        fi
      done
    elif [[ -z "$dest" ]]; then
      dest="$arg"
    else
      return 1
    fi
  done

  [[ -n "$dest" ]] || return 1

  local resolved
  resolved="$(command ssh -G "${argv[@]}" 2>/dev/null)" || return 1
  ! grep -i '^remotecommand ' <<<"$resolved" | grep -qvi '^remotecommand none$'
}

# Git worktrees
unalias ga gd 2>/dev/null || true

ga() {
  [[ -n "${1:-}" ]] || {
    print -u2 'usage: ga <branch-name>'
    return 2
  }

  local branch="$1"
  local base="${PWD:t}"
  local worktree_path="../${base}--${branch}"

  git worktree add -b "$branch" "$worktree_path" || return
  command -v mise >/dev/null 2>&1 && mise trust "$worktree_path"
  cd "$worktree_path" || return
}

gd() {
  local cwd="$PWD" worktree="${PWD:t}" root branch
  root="${worktree%%--*}"
  branch="${worktree#*--}"

  [[ "$root" != "$worktree" ]] || {
    print -u2 'current directory does not look like a managed worktree'
    return 1
  }

  if command -v gum >/dev/null 2>&1; then
    gum confirm 'Remove worktree and branch?' || return
  else
    local reply
    read "reply?Remove worktree and branch? [y/N] "
    [[ "$reply" == [Yy] ]] || return
  fi

  cd "../$root" || return
  git worktree remove "$cwd" --force || return
  git branch -D "$branch"
}

# Tmux development layouts
tdl() {
  [[ -n "${1:-}" ]] || {
    print -u2 'usage: tdl <ai-command> [second-ai-command]'
    return 2
  }
  [[ -n "${TMUX:-}" ]] || {
    print -u2 'tdl must be run inside tmux'
    return 1
  }

  local current_dir="$PWD" editor_pane="$TMUX_PANE" ai_pane ai2_pane
  local ai="$1" ai2="${2:-}"

  tmux rename-window -t "$editor_pane" "${current_dir:t}"
  tmux split-window -v -p 15 -t "$editor_pane" -c "$current_dir"
  ai_pane="$(tmux split-window -h -p 30 -t "$editor_pane" -c "$current_dir" -P -F '#{pane_id}')" || return

  if [[ -n "$ai2" ]]; then
    ai2_pane="$(tmux split-window -v -t "$ai_pane" -c "$current_dir" -P -F '#{pane_id}')" || return
    tmux send-keys -t "$ai2_pane" -l "$ai2"
    tmux send-keys -t "$ai2_pane" Enter
  fi

  tmux send-keys -t "$ai_pane" -l "$ai"
  tmux send-keys -t "$ai_pane" Enter
  tmux send-keys -t "$editor_pane" -l "${EDITOR:-nvim} ."
  tmux send-keys -t "$editor_pane" Enter
  tmux select-pane -t "$editor_pane"
}

tds() {
  (( $# == 0 )) || {
    print -u2 'usage: tds'
    return 2
  }
  [[ -n "${TMUX:-}" ]] || {
    print -u2 'tds must be run inside tmux'
    return 1
  }

  local current_dir="$PWD" editor_pane="$TMUX_PANE"
  local terminal_pane diff_pane opencode_pane

  tmux rename-window -t "$editor_pane" "${current_dir:t}"
  terminal_pane="$(tmux split-window -v -p 50 -t "$editor_pane" -c "$current_dir" -P -F '#{pane_id}')" || return
  diff_pane="$(tmux split-window -h -p 50 -t "$editor_pane" -c "$current_dir" -P -F '#{pane_id}')" || return
  opencode_pane="$(tmux split-window -h -p 50 -t "$terminal_pane" -c "$current_dir" -P -F '#{pane_id}')" || return

  tmux send-keys -t "$editor_pane" -l 'nvim .'
  tmux send-keys -t "$editor_pane" Enter
  tmux send-keys -t "$diff_pane" -l 'hunk diff --watch'
  tmux send-keys -t "$diff_pane" Enter
  tmux send-keys -t "$opencode_pane" -l 'opencode'
  tmux send-keys -t "$opencode_pane" Enter
  tmux select-pane -t "$editor_pane"
}

tdlm() {
  [[ -n "${1:-}" ]] || {
    print -u2 'usage: tdlm <ai-command> [second-ai-command]'
    return 2
  }
  [[ -n "${TMUX:-}" ]] || {
    print -u2 'tdlm must be run inside tmux'
    return 1
  }

  local ai="$1" ai2="${2:-}" base_dir="$PWD" dir dirpath pane_id command
  local first=1

  local session_name="${base_dir:t}"
  session_name="${session_name//[.:]/-}"
  tmux rename-session "$session_name"
  for dir in "$base_dir"/*(/N); do
    dirpath="${dir%/}"
    printf -v command 'cd %q && tdl %q' "$dirpath" "$ai"
    [[ -n "$ai2" ]] && printf -v command '%s %q' "$command" "$ai2"

    if (( first )); then
      tmux send-keys -t "$TMUX_PANE" -l "$command"
      tmux send-keys -t "$TMUX_PANE" Enter
      first=0
    else
      pane_id="$(tmux new-window -c "$dirpath" -P -F '#{pane_id}')" || return
      tmux send-keys -t "$pane_id" -l "$command"
      tmux send-keys -t "$pane_id" Enter
    fi
  done
}

tsl() {
  (( $# >= 2 )) || {
    print -u2 'usage: tsl <pane-count> <command>'
    return 2
  }
  [[ -n "${TMUX:-}" ]] || {
    print -u2 'tsl must be run inside tmux'
    return 1
  }
  [[ "$1" == <1-> ]] || {
    print -u2 'pane-count must be a positive integer'
    return 2
  }

  local count="$1" command="$2" current_dir="$PWD" pane new_pane
  local -a panes=("$TMUX_PANE")

  tmux rename-window -t "$TMUX_PANE" "${current_dir:t}"
  while (( ${#panes[@]} < count )); do
    new_pane="$(tmux split-window -h -t "${panes[-1]}" -c "$current_dir" -P -F '#{pane_id}')" || return
    panes+=("$new_pane")
    tmux select-layout -t "${panes[1]}" tiled
  done

  for pane in "${panes[@]}"; do
    tmux send-keys -t "$pane" -l "$command"
    tmux send-keys -t "$pane" Enter
  done
  tmux select-pane -t "${panes[1]}"
}
