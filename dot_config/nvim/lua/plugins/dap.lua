vim.pack.add({
    "https://github.com/mfussenegger/nvim-dap",
    "https://github.com/rcarriga/nvim-dap-ui",
    "https://github.com/nvim-neotest/nvim-nio", -- nvim-dap-ui dependency
    "https://github.com/mfussenegger/nvim-dap-python",
    "https://github.com/theHamsta/nvim-dap-virtual-text",
})

local dap = require("dap")
local dapui = require("dapui")

dapui.setup()
require("nvim-dap-virtual-text").setup()

-- Auto open/close the UI when a debug session starts/ends
dap.listeners.before.attach.dapui_config = function()
    dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
    dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
    dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
    dapui.close()
end

-- Python (debugpy, installed via mason) =====================================

local mason_packages = vim.fn.stdpath("data") .. "/mason/packages"
require("dap-python").setup(mason_packages .. "/debugpy/venv/bin/python")

-- C/C++ (codelldb, installed via mason) ======================================

local codelldb_root = mason_packages .. "/codelldb/extension"

dap.adapters.codelldb = {
    type = "server",
    port = "${port}",
    executable = {
        command = codelldb_root .. "/adapter/codelldb",
        args = { "--port", "${port}", "--liblldb", codelldb_root .. "/lldb/lib/liblldb.dylib" },
    },
}

dap.configurations.cpp = {
    {
        name = "Launch file",
        type = "codelldb",
        request = "launch",
        program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
    },
}
dap.configurations.c = dap.configurations.cpp

-- Keymaps =====================================================================
-- Execution flow on F-keys (matches VSCode/most IDEs, avoids the crowded <leader> namespace)

vim.keymap.set("n", "<F5>", dap.continue, { desc = "DAP: Continue/Start" })
vim.keymap.set("n", "<F9>", dap.toggle_breakpoint, { desc = "DAP: Toggle breakpoint" })
vim.keymap.set("n", "<F10>", dap.step_over, { desc = "DAP: Step over" })
vim.keymap.set("n", "<F11>", dap.step_into, { desc = "DAP: Step into" })
vim.keymap.set("n", "<S-F11>", dap.step_out, { desc = "DAP: Step out" })

vim.keymap.set("n", "<leader>uu", dapui.toggle, { desc = "Toggle DAP UI" })
vim.keymap.set("n", "<leader>ub", function()
    dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "Conditional breakpoint" })
vim.keymap.set("n", "<leader>ur", dap.repl.toggle, { desc = "Toggle DAP REPL" })
vim.keymap.set("n", "<leader>ut", dap.terminate, { desc = "Terminate debug session" })
