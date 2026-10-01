#!/usr/bin/env sh
# Right-side status-bar host segment: "local" for a normal shell, or the
# ssh target while the active pane is connected somewhere — instead of
# always showing this machine's own hostname (#h), which doesn't change
# no matter where you're actually working.
# Args: $1=pane_current_command $2=pane_tty
cmd="$1"
tty="$2"
script_dir="$(dirname "$0")"

if [ "$cmd" = "ssh" ]; then
  host=$("$script_dir/ssh-target.sh" "$tty")
  printf '%s' "${host:-ssh}"
else
  printf 'local'
fi
