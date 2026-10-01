vim.pack.add({ "https://github.com/MeanderingProgrammer/render-markdown.nvim" })

require("render-markdown").setup({})

vim.keymap.set("n", "<leader>mp", "<cmd>RenderMarkdown toggle<CR>", { desc = "Toggle Markdown render" })
