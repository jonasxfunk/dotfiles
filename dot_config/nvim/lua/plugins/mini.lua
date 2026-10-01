vim.pack.add({ "https://github.com/echasnovski/mini.nvim" })

require("mini.ai").setup() -- better a/i text objects

-- gcc / gc; commentstring is treesitter-context-aware (e.g. JS inside a Vue/Svelte
-- file), via plugins.treesitter's ts_context_commentstring setup
require("mini.comment").setup({
	options = {
		custom_commentstring = function()
			return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
		end,
	},
})
require("mini.move").setup() -- Alt+hjkl to move lines/selection (replaces old <A-j>/<A-k> mappings)
require("mini.surround").setup() -- sa/sd/sr/sf/sF/sh to add/delete/replace/find surroundings
require("mini.cursorword").setup() -- auto-highlight word under cursor
require("mini.indentscope").setup() -- animated indent scope guide
require("mini.trailspace").setup() -- highlight trailing whitespace (Normal mode only)
require("mini.bufremove").setup() -- delete buffer without closing the window layout

-- Underline instead of Everforest's default bold-only cursorword highlight
vim.api.nvim_set_hl(0, "MiniCursorword", { underline = true })
vim.api.nvim_set_hl(0, "MiniCursorwordCurrent", { underline = true })

-- Trailspace is only visible in Normal mode by design (avoids flicker while typing),
-- so trim automatically on save instead of relying on spotting it manually.
vim.api.nvim_create_autocmd("BufWritePre", {
	group = vim.api.nvim_create_augroup("MiniTrailspaceTrim", { clear = true }),
	callback = function()
		require("mini.trailspace").trim()
	end,
	desc = "Trim trailing whitespace on save",
})

-- mini.hipatterns: highlight hex color codes (e.g. #D8DEE9) with their
-- actual color as the background
require("mini.hipatterns").setup({
	highlighters = {
		hex_color = require("mini.hipatterns").gen_highlighter.hex_color(),
	},
})

-- mini.icons: provides icons for yazi.nvim, fzf-lua, etc. without a separate
-- nvim-web-devicons install
require("mini.icons").setup()
require("mini.icons").mock_nvim_web_devicons()

-- mini.notify: nicer floating notifications instead of the classic message area
require("mini.notify").setup({
	lsp_progress = { enable = false },
})
vim.notify = require("mini.notify").make_notify()

vim.keymap.set("n", "<leader>tw", function()
	require("mini.trailspace").trim()
end, { desc = "Trim trailing whitespace" })

vim.keymap.set("n", "<leader>bd", function()
	require("mini.bufremove").delete()
end, { desc = "Delete buffer (keep window layout)" })
