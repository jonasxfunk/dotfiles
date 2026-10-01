local keymap = vim.keymap

-- Navigation in wrapped text
keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = "Down (wrap-aware)" })
keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = "Up (wrap-aware)" })

-- Search adjustments
keymap.set("n", "<leader>c", ":nohlsearch<CR>", { desc = "Clear search highlights" })
keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })

-- Clipboard & Editing modifications
keymap.set("x", "<leader>p", '"_dP', { desc = "Paste without losing current yank register" })
keymap.set({ "n", "v" }, "<leader>x", '"_d', { desc = "Delete text without yanking it" })
keymap.set("n", "J", "mzJ`z", { desc = "Join lines while preserving current cursor position" })

-- <C-z> defaults to suspending Neovim in the terminal; make it undo instead (u stays untouched)
keymap.set("n", "<C-z>", "u", { desc = "Undo" })
keymap.set("i", "<C-z>", "<C-o>u", { desc = "Undo" })

-- Buffer navigation
keymap.set("n", "<leader>bn", ":bnext<CR>", { desc = "Go to next buffer" })
keymap.set("n", "<leader>bp", ":bprevious<CR>", { desc = "Go to previous buffer" })

-- Window split navigation (Tmux integrated compatible mappings)
keymap.set("n", "<C-h>", "<cmd>TmuxNavigateLeft<CR>", { desc = "Move to the left window/pane" })
keymap.set("n", "<C-j>", "<cmd>TmuxNavigateDown<CR>", { desc = "Move to the bottom window/pane" })
keymap.set("n", "<C-k>", "<cmd>TmuxNavigateUp<CR>", { desc = "Move to the top window/pane" })
keymap.set("n", "<C-l>", "<cmd>TmuxNavigateRight<CR>", { desc = "Move to the right window/pane" })

-- Window creation and resizing
keymap.set("n", "<leader>sv", ":vsplit<CR>", { desc = "Split window vertically" })
keymap.set("n", "<leader>sh", ":split<CR>", { desc = "Split window horizontally" })
keymap.set("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height" })
keymap.set("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

-- Moving visual selections and lines up/down/left/right: see plugins.mini (mini.move)

-- Indenting while maintaining current block selection
keymap.set("v", "<", "<gv", { desc = "Indent left and re-select text" })
keymap.set("v", ">", ">gv", { desc = "Indent right and re-select text" })

-- Utility functions
keymap.set("n", "<leader>pa", function()
	local path = vim.fn.expand("%:p")
	vim.fn.setreg("+", path)
	print("file:", path)
end, { desc = "Copy absolute file path to system clipboard" })

keymap.set("n", "<leader>td", function()
	vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle code diagnostics display" })
