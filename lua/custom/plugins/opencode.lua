return {
    "NickvanDyke/opencode.nvim",
    dependencies = {
        -- Recommended for `ask()` and `select()`.
        -- Required for `snacks` provider.
        ---@module 'snacks'
        { "folke/snacks.nvim", lazy = false, priority = 1000, opts = { input = {}, picker = {} } },
    },
    version = "*",
    config = function()
        local term = require("custom.term").new()

        ---@type opencode.Opts
        vim.g.opencode_opts = {
            server = {
                start = function()
                    term:create_term("right", "term://opencode --port")
                end,
            },
        }

        -- Required for `opts.events.reload`.
        vim.o.autoread = true

        -- Recommended/example keymaps.
        vim.keymap.set({ "n", "x" }, "<leader>o", function()
            require("opencode").select()
        end, { desc = "Execute opencode action…" })
        vim.keymap.set({ "n", "t" }, "<C-.>", function()
            if not term.chan then
                term:create_term("right", "term://opencode --port")
                return
            end
            term:toggle()
        end, { desc = "Toggle opencode" })

        vim.keymap.set({ "n", "x" }, "go", function()
            return require("opencode").operator("@this ")
        end, { desc = "Add range to opencode", expr = true })
        vim.keymap.set("n", "goo", function()
            return require("opencode").operator("@this ") .. "_"
        end, { desc = "Add line to opencode", expr = true })

        -- You may want these if you stick with the opinionated "<C-a>" and "<C-x>" above — otherwise consider "<leader>o…".
        vim.keymap.set("n", "+", "<C-a>", { desc = "Increment under cursor", noremap = true })
        vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement under cursor", noremap = true })
    end,
}
