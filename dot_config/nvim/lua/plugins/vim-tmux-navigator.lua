-- Works even without tmux (falls back to plain window navigation when $TMUX
-- isn't set) — the Ctrl+h/j/k/l mappings in core/keymaps.lua only fully make
-- sense once you also set up tmux.conf, but this alone already fixes plain
-- nvim split navigation on those keys today.
vim.pack.add({ "https://github.com/christoomey/vim-tmux-navigator" })
