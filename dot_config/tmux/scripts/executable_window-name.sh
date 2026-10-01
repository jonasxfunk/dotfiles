#!/usr/bin/env sh
# Computes the live window name shown by window-status-format/-current-format
# in tmux.conf (called there as a #() job on every status-line redraw):
#   - idle shell            -> cwd's basename, instead of a flat "zsh"
#   - ssh                   -> "<target> (ssh)", via ssh-target.sh
#   - nvim                  -> the open file's basename, via #{pane_title}
#                              (nvim pushes it with an OSC-2 title escape,
#                              see core/options.lua's titlestring; falls
#                              back to the cwd if nvim hasn't set one yet)
#   - anything else         -> unchanged, tmux's normal #{pane_current_command}
#
# Args: $1=pane_current_command $2=pane_current_path $3=pane_title $4=pane_tty
cmd="$1"
path="$2"
title="$3"
tty="$4"
script_dir="$(dirname "$0")"

case "$cmd" in
  ssh)
    host=$("$script_dir/ssh-target.sh" "$tty")
    printf '%s (ssh)' "${host:-?}"
    ;;
  nvim|vim)
    if [ -n "$title" ] && [ "$title" != "$cmd" ]; then
      printf '%s' "$title"
    else
      printf '%s' "$(basename "$path")"
    fi
    ;;
  zsh|bash|sh|fish)
    printf '%s' "$(basename "$path")"
    ;;
  *)
    printf '%s' "$cmd"
    ;;
esac
