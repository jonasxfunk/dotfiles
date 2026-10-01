
export FZF_DEFAULT_COMMAND='fd --type f --hidden --strip-cwd-prefix'
# Note: fd is fdfind on ubuntu

# ctrl-T uses fd
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# alt-c (cd picker) uses fd, dirs only
export FZF_ALT_C_COMMAND="fd --type d --hidden --strip-cwd-prefix"

# Compact UI
export FZF_DEFAULT_OPTS='
	--height 60%
	--layout=reverse
	--border=rounded
	--prompt="  "
	--pointer="  "
	--preview-window=right:65%:wrap:border-left
'

export _FZF_PREVIEW_CMD='bat --color=always --style=plain,numbers --line-range=:500 {}'
export FZF_CTRL_T_OPTS="--preview '$_FZF_PREVIEW_CMD'"



# ctrl-F: file picker excluding hidden files
_fzf_file_no_hidden() {
	local cmd result
	cmd="${FZF_DEFAULT_COMMAND/--hidden /}"
	result=$(eval "${cmd:-find . -type f}" | fzf --preview "$_FZF_PREVIEW_CMD") && LBUFFER+="$result"
	zle reset-prompt
}
zle -N _fzf_file_no_hidden
