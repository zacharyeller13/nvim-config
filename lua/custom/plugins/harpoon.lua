local module = {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
    config = function()
        -- Harpoon keymaps
        local harpoon = require("harpoon")
        -- Calling setup is required
        harpoon:setup({
            settings = {
                save_on_toggle = true,
            },
        })
        vim.keymap.set("n", "<leader>a", function()
            harpoon:list():add()
        end, { desc = "[A]dd to Harpoon" })
        vim.keymap.set("n", "<C-e>", function()
            harpoon.ui:toggle_quick_menu(harpoon:list())
        end)
        vim.keymap.set("n", "<C-h>", function()
            harpoon:list():select(1)
        end, { desc = "Switch to harpoon 1" })
        vim.keymap.set("n", "<C-j>", function()
            harpoon:list():select(2)
        end, { desc = "Switch to harpoon 2" })
        vim.keymap.set("n", "<C-k>", function()
            harpoon:list():select(3)
        end, { desc = "Switch to harpoon 3" })
        vim.keymap.set("n", "<C-l>", function()
            harpoon:list():select(4)
        end, { desc = "Switch to harpoon 4" })

        local harpoon_extensions = require("harpoon.extensions")
        harpoon:extend(harpoon_extensions.builtins.highlight_current_file())
    end,
}

return module
