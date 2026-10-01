-- Leader-Key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Load core settings and keymaps
require("core.options")
require("core.keymaps")

-- Load plugins and themes first, so highlight groups exist before we touch them
require("plugins.colorscheme")
require("plugins.treesitter")
require("plugins.yazi")
require("plugins.fzf-lua")
require("plugins.autopairs")
require("plugins.mini")
require("plugins.gitsigns")
require("plugins.fugitive")
require("plugins.lsp")
require("plugins.which-key")
require("plugins.dap")
require("plugins.vim-tmux-navigator")
require("plugins.render-markdown")
require("plugins.iron")
-- Load statusline after the colorscheme, so its highlights aren't overwritten
require("core.statusline")

-- Load autocommands
require("core.autocommands")
