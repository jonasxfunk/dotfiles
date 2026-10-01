vim.pack.add({ "https://github.com/windwp/nvim-autopairs" })

local autopairs = require("nvim-autopairs")
autopairs.setup({})

-- Don't auto-pair quotes in prose (apostrophes in contractions, inline quotation marks) —
-- brackets still pair everywhere, including fenced code blocks inside markdown.
local prose_filetypes = { "markdown", "text", "gitcommit" }
autopairs.get_rules("'")[1].not_filetypes = prose_filetypes
autopairs.get_rules('"')[1].not_filetypes = prose_filetypes
