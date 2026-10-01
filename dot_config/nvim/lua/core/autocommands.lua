local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })

-- Format on save (any real file buffer, only when efm is attached)
vim.api.nvim_create_autocmd("BufWritePre", {
    group = augroup,
    pattern = "*",
    callback = function(args)
        -- avoid formatting non-file buffers (helps prevent weird write prompts)
        if vim.bo[args.buf].buftype ~= "" then
            return
        end
        if not vim.bo[args.buf].modifiable then
            return
        end
        if vim.api.nvim_buf_get_name(args.buf) == "" then
            return
        end

        local has_efm = false
        for _, c in ipairs(vim.lsp.get_clients({ bufnr = args.buf })) do
            if c.name == "efm" then
                has_efm = true
                break
            end
        end
        if not has_efm then
            return
        end

        pcall(vim.lsp.buf.format, {
            bufnr = args.buf,
            timeout_ms = 2000,
            filter = function(c)
                return c.name == "efm"
            end,
        })
    end,
})

-- highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
    group = augroup,
    callback = function ()
        vim.hl.on_yank()
    end,
})

-- return to last cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
    group = augroup,
    desc = "Restore last cursor position",
    callback = function()
        if vim.o.diff then -- except in diff mode
            return
        end

        local last_pos = vim.api.nvim_buf_get_mark(0, '"') -- {line, col}
        local last_line = vim.api.nvim_buf_line_count(0)

        local row = last_pos[1]
        if row < 1 or row > last_line then
            return
        end

        pcall(vim.api.nvim_win_set_cursor, 0, last_pos)
    end,
})

-- Enter terminal (job) mode automatically on opening a :terminal, and hide
-- line numbers there — without this, keys go to nvim's own text cursor
-- (letting it move character-by-character over whatever a TUI renders as
-- text) instead of straight to the running program.
vim.api.nvim_create_autocmd("TermOpen", {
    group = augroup,
    callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.signcolumn = "no"
        vim.cmd.startinsert()
    end,
})

-- wrap, linebreak and spellcheck on markdown and text files
vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    pattern = {"markdown", "text", "gitcommit" },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true
        vim.opt_local.spell = true
    end,
})

