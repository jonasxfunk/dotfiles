vim.pack.add({ "https://github.com/Vigemus/iron.nvim" })

local iron = require("iron.core")
local view = require("iron.view")
local common = require("iron.fts.common")

iron.setup({
	config = {
		scratch_repl = true,
		repl_definition = {
			python = {
				command = function()
					return { "uv", "run", "ipython", "--no-autoindent" }
				end,
				format = common.bracketed_paste_python,
				env = { PYTHON_BASIC_REPL = "1" },
				block_dividers = { "# %%" },
			},
		},
		repl_open_cmd = view.bottom(15),
	},
	keymaps = {
		toggle_repl = "<localleader>rr",
		send_motion = "<localleader>sc",
		visual_send = "<localleader>sc",
		send_file = "<localleader>sf",
		send_line = "<localleader>sl",
		send_paragraph = "<localleader>sp",
		send_code_block = "<localleader>sb",
		clear = "<localleader>rc",
	},

	highlight = { italic = true },
	ignore_blank_lines = true,
})
-- Jump to the next "# %%" cell marker without running anything
vim.keymap.set("n", "<localleader>bn", "/^# %%<CR>", { silent = true, desc = "Jump to nect cell marker" })

-- Clear + jump to next cell + run it
vim.keymap.set("n", "<localleader>bx", function()
	local keys = vim.api.nvim_replace_termcodes("<localleader>rc<localleader>bn<localleader>sb", true, false, true)
	vim.api.nvim_feedkeys(keys, "m", false)
end, { silent = true, desc = "Iron: clear + next cell + run" })
