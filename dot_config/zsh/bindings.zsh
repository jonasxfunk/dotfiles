
bindkey -e

bindkey '^F' _fzf_file_no_hidden
bindkey '^R' fzf-history-widget
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

# Option+Left/Right (Alt-Modifier = ;3 statt ;5 fuer Ctrl)
bindkey '^[[1;3D' backward-word
bindkey '^[[1;3C' forward-word
