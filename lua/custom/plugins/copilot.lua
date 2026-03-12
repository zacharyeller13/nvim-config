local M = {
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        enabled = false,
        config = function()
            require("copilot").setup({})
        end,
    },
}

return M
