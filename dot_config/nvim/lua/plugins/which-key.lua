vim.pack.add({ "https://github.com/folke/which-key.nvim" })

require("which-key").setup({})

-- Label the leader-prefix groups so the popup reads clearly instead of a flat list
require("which-key").add({
    { "<leader>f", group = "find (fzf-lua / lsp)" },
    { "<leader>h", group = "git hunk (gitsigns)" },
    { "<leader>g", group = "goto (lsp) / git" },
    { "<leader>b", group = "buffer" },
    { "<leader>s", group = "split" },
    { "<leader>t", group = "toggle" },
    { "<leader>u", group = "debugger (dap)" },
})
