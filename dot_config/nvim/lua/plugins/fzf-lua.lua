vim.pack.add({ "https://github.com/ibhagwan/fzf-lua" })

require("fzf-lua").setup({
	winopts = {
		height = 0.85,
		width = 0.85,
	},
})

local fzf = require("fzf-lua")
vim.keymap.set("n", "<leader>ff", fzf.files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", fzf.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", fzf.buffers, { desc = "Find buffers" })
vim.keymap.set("n", "<leader>fh", fzf.helptags, { desc = "Help tags" })
vim.keymap.set("n", "<leader>fr", fzf.oldfiles, { desc = "Recent files" })
vim.keymap.set("n", "<leader>fw", fzf.grep_cword, { desc = "Grep word under cursor" })
vim.keymap.set("n", "<leader>fx", fzf.diagnostics_document, { desc = "Diagnostics Document" })
vim.keymap.set("n", "<leader>fX", fzf.diagnostics_workspace, { desc = "Diagnostics Workspace" })
vim.keymap.set("n", "<leader>fl", fzf.lines, { desc = "Search buffer" })
