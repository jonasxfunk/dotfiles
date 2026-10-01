#!/usr/bin/env sh
# Prints the target host of the ssh process running on the given tty (empty
# if none can be found). Shared by window-name.sh and host-status.sh so the
# ps/awk parsing (tmux only exposes the command name "ssh", not its args)
# lives in one place.
tty="${1#/dev/}"

ps -ax -o tty=,args= 2>/dev/null \
  | awk -v tty="$tty" '$1==tty && $2=="ssh"{ $1=$2=""; print; exit }' \
  | awk '{for(i=1;i<=NF;i++) if ($i !~ /^-/) last=$i} END{print last}'
