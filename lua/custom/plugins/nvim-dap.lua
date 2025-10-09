---@type LazyPluginSpec
local M = {
    "mfussenegger/nvim-dap",
    dependencies = {
        "mfussenegger/nvim-dap-python",
        "rcarriga/nvim-dap-ui",
        "nvim-neotest/nvim-nio",
        "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
        local dap = require("dap")
        local ui = require("dapui")

        require("dapui").setup()
        require("nvim-dap-virtual-text").setup({})
        require("dap-python").setup("uv")

        vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "DAP: Toggle [B]reakpoint" })
        vim.keymap.set("n", "<leader>gb", dap.run_to_cursor, { desc = "DAP: Run to Cursor" })

        vim.keymap.set("n", "<leader>?", function()
            ui.eval(nil, { enter = true })
        end)

        vim.keymap.set("n", "<F8>", dap.continue)
        vim.keymap.set("n", "<F9>", dap.step_over)
        vim.keymap.set("n", "<F7>", dap.step_back)
        vim.keymap.set("n", "<Down>", dap.step_into)
        vim.keymap.set("n", "<Up>", dap.step_out)
        vim.keymap.set("n", "<Left><Right>", dap.restart)

        dap.listeners.before.attach.dapui_config = function()
            ui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
            ui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
            ui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
            ui.close()
        end
    end,
}

return M
