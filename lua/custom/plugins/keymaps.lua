-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Move quickfix list, apparently will be autoset in nvim 0.11
if not vim.fn.has("nvim-0.11") == 1 then
    vim.keymap.set("n", "[q", function()
        if #vim.fn.getqflist() ~= 0 then
            return vim.cmd.cprev()
        end
    end, { desc = "Go to previous [Q]uickfix item" })
    vim.keymap.set("n", "]q", function()
        if #vim.fn.getqflist() ~= 0 then
            return vim.cmd.cnext()
        end
    end, { desc = "Go to next [Q]uickfix item" })
end

-- Run lua code when necessary
vim.keymap.set("n", "<space><space>x", "<cmd>source %<CR>")
vim.keymap.set("n", "<space>x", ":.lua<CR>")
vim.keymap.set("v", "<space>x", ":lua<CR>")

-- Setup to use mini.files
vim.keymap.set("n", "<leader>pv", function()
    -- Defined when in init.lua we run require('mini.files').setup()
    MiniFiles.open()
end, { desc = "Open Files (mini.files)" })

-- Map the Escape cmd to jj in most contexts
-- Already mapped to <C-[>
-- <C-c> is like Esc!, don't run anything like LSP
vim.keymap.set("i", "jj", "<Escape>", { desc = "Escape" })
vim.keymap.set("c", "jj", "<Escape>", { desc = "Escape" })

-- Format using conform
vim.keymap.set("n", "<leader>f", function()
    require("conform").format({ async = true }, function(err, did_edit)
        if did_edit then
            print("Formatted!")
        end
        if err then
            print(err)
        end
    end)
end, { desc = "[F]ormat file" })

-- Keep the cursor in the middle when paging up/down
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
return {}
