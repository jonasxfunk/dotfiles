-- Disable netrw before yazi.nvim is set up (needed for open_for_directories,
-- so opening a directory opens yazi instead of netrw)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.pack.add({
    "https://github.com/nvim-lua/plenary.nvim", -- yazi.nvim's only dependency
    "https://github.com/mikavilpas/yazi.nvim",
})

require("yazi").setup({
    open_for_directories = true,
})

vim.keymap.set("n", "<leader>e", function()
    require("yazi").yazi()
end, { desc = "Open yazi at the current file" })
