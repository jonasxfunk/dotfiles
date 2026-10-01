local opt = vim.opt

-- Appearance & UI
opt.termguicolors = true			-- Enable 24-bit RGB colors
opt.number = true				-- Show line numbers
opt.relativenumber = true			-- Show relative line numbers
opt.cursorline = true				-- Highlight the current screen line
opt.wrap = false				-- Do not wrap lines by default
opt.scrolloff = 10				-- Keep at least 10 lines above/below the cursor
opt.sidescrolloff = 10				-- Keep at least 10 columns to the left/right of the cursor
opt.signcolumn = "yes"				-- Always show the sign column to prevent layout shifts
opt.colorcolumn = "100"				-- Highlight column 100 as a guide for line length
opt.cmdheight = 0				-- Hide the command-line row when idle; messages show as an overlay
opt.showmode = false				-- Hide the default mode indicator (e.g., -- INSERT --)

-- Tabs & Indentation
opt.tabstop = 4					-- Number of spaces that a <Tab> counts for
opt.shiftwidth = 4				-- Number of spaces to use for each step of auto-indent
opt.softtabstop = 4				-- Number of spaces that a <Tab> counts for while editing
opt.expandtab = true				-- Convert tabs into spaces
-- smartindent is off on purpose: it hardcodes '#' as a C-preprocessor
-- directive and force-outdents any line starting with it to column 0,
-- which ruins indented comments in Python/shell/etc. Filetype-aware
-- indentation (enabled by default) and treesitter already indent
-- correctly without that quirk.
opt.smartindent = false

-- Search Configuration
opt.ignorecase = true				-- Case-insensitive searching
opt.smartcase = true				-- Case-sensitive if the search query contains uppercase

-- Menus & Windows
opt.completeopt = "menuone,noinsert,noselect"	-- Completion menu options
opt.pumheight = 10				-- Maximum number of items to show in the popup menu
opt.pumblend = 10				-- Transparency level for the popup menu
opt.splitbelow = true				-- Horizontal splits will open below the current window
opt.splitright = true				-- Vertical spplits will open to the right of the current window
opt.wildmode = "longest:full,full"		-- Command-line completion behavior

-- Performance & System
opt.updatetime = 300				-- Faster completion and diagnostic updates (default is 4000ms)
opt.timeoutlen = 500				-- Time in ms to wait for a mapped sequence to complete
opt.mouse = "a"					-- Enable mouse support in all modes (default excludes command-line mode)
opt.redrawtime = 10000				-- Timeout for redrawing the screen in ms
opt.maxmempattern = 20000			-- Maximum memory pattern for matching syntax
opt.iskeyword:append("-")			-- Include dashes as part of a word definition
opt.path:append("**")				-- Search down into subdirectories
opt.clipboard:append("unnamedplus")		-- Use the system clipboard for all yanks and deletes

-- Cursor styling
opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"

-- Code Folding
opt.foldmethod = "expr"				-- Use an expression to determine code folds
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- Use Treesitter for robust code folding
opt.foldlevel = 99				-- Start with all folds open

-- Persistent Undo Configuration
local undodir = vim.fn.stdpath("cache") .. "/undo"
if vim.fn.isdirectory(undodir) == 0 then
	vim.fn.mkdir(undodir, "p")		-- Create the undo directory in Neovim's cache folder
end
opt.writebackup = false				-- Do not write backups before overwriting a file
opt.swapfile = false				-- Do not use swap files
opt.undofile = true				-- Enable persistent undo tracking across sessions
opt.undodir = undodir				-- Set the active undo folder

-- Terminal title: push the open file's name via an OSC-2 escape so tmux
-- picks it up into #{pane_title} (used by tmux's window-name.sh script to
-- show the actual filename instead of just "nvim" in the status bar).
opt.title = true
opt.titlestring = "%t"

-- Custom UI Adjustments
opt.conceallevel = 2				-- Hide specific markup (required for Obsidian plugins)
opt.synmaxcol = 300				-- Limit syntax highlighting to 300 columns for speed
opt.fillchars = { eob = " "}			-- Hide the default "~" characters on empty lines
