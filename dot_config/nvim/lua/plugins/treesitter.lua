vim.pack.add({
    "https://github.com/nvim-treesitter/nvim-treesitter",
    { src = "https://github.com/JoosepAlviste/nvim-ts-context-commentstring", name = "nvim-ts-context-commentstring" },
})

local treesitter = require("nvim-treesitter")
treesitter.setup({})

local ensure_installed = {
    "vim",
    "vimdoc",
    "rust",
    "c",
    "cpp",
    "go",
    "html",
    "css",
    "javascript",
    "json",
    "lua",
    "markdown",
    "python",
    "typescript",
    "vue",
    "svelte",
    "bash",
    "yaml",
    "toml",
}

local already_installed = treesitter.get_installed()
local parsers_to_install = {}

for _, parser in ipairs(ensure_installed) do
    if not vim.list_contains(already_installed, parser) then
        table.insert(parsers_to_install, parser)
    end
end

if #parsers_to_install > 0 then
    treesitter.install(parsers_to_install)
end

-- Start treesitter highlighting/folding for any filetype whose parser is installed
-- (this is also what makes options.lua's treesitter-based foldexpr actually work)
local group = vim.api.nvim_create_augroup("TreeSitterConfig", {})
vim.api.nvim_create_autocmd("FileType", {
    group = group,
    callback = function(args)
        local lang = vim.treesitter.language.get_lang(args.match)
        if lang and vim.list_contains(treesitter.get_installed(), lang) then
            vim.treesitter.start(args.buf)
        end
    end,
})

require("ts_context_commentstring").setup({
    enable_autocmd = false,
})
