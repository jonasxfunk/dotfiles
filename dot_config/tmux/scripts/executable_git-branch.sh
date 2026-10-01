#!/usr/bin/env sh
# Prints " <branch>" for the given pane's cwd, or nothing if it isn't
# inside a git repo. Called from tmux.conf's status-right on every
# status-interval via #(...) — keep this fast and dependency-free.
dir="$1"
branch=$(git -C "$dir" branch --show-current 2>/dev/null)
[ -n "$branch" ] && printf ' %s' "$branch"
