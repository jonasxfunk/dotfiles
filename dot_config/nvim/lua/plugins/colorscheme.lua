-- Download and register the Everforest theme via the built-in package system
vim.pack.add({ "https://github.com/neanias/everforest-nvim" })

-- Configure Everforest settings BEFORE calling the colorscheme command
-- Options for background: "hard" (darkest), "medium" (default), "soft" (lighter dark)
vim.g.everforest_background = "medium"

-- Enable specific Everforest features
vim.g.everforest_enable_italic = 1
vim.g.everforest_diagnostic_text_highlight = 1

-- Apply the colorscheme
vim.cmd.colorscheme("everforest")

-- Strip background highlights for a transparent window effect
-- (Remove/comment out this block if you prefer Everforest's solid background)
local transparent_groups = {
	"Normal",
	"NormalNC",
	"EndOfBuffer",
	"NormalFloat",
	"FloatBorder",
	"SignColumn",
	"TabLine",
	"TabLineFill",
	"TabLineSel",
}
for _, g in ipairs(transparent_groups) do
	vim.api.nvim_set_hl(0, g, { bg = "none" })
end
-- Custom foreground configuration for the tab line filler area
vim.api.nvim_set_hl(0, "TabLineFill", { bg = "none", fg = "#767676" })

-- Visual-mode selection: Everforest's own bg_visual (#543A48) blends in too
-- much against the dark background to notice at a glance; lightened while
-- keeping the same hue so it still reads as "Everforest", just visible.
vim.api.nvim_set_hl(0, "Visual", { bg = "#735D69" })
