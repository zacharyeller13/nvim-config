local buffer = require("string.buffer")
-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Move quickfix list, apparently will be autoset in nvim 0.11
if vim.fn.has("nvim-0.11") ~= 1 then
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

-- nvim 0.13 has multicursor and default <C-L> conflicts with harpoon keybind
-- So we rebind a different keymap to fix that using
-- the fact that mcursors are in the nvim.multicursor namespace as extmarks
-- and there is not built-in to clear them other than the <C-L> default
if vim.fn.has("nvim-0.13") == 1 then
    vim.keymap.set("n", "<leader>mc", function()
        local namespaces = vim.api.nvim_get_namespaces()
        for name, id in pairs(namespaces) do
            if name == "nvim.multicursor" then
                vim.api.nvim_buf_clear_namespace(0, id, 0, -1)
            end
        end
    end, { desc = "[m]ulticursor [c]lear" })
end

-- Run lua code when necessary
vim.keymap.set("n", "<space><space>x", "<cmd>source %<CR>")
vim.keymap.set("n", "<space>x", ":.lua<CR>")
vim.keymap.set("v", "<space>x", ":lua<CR>")

-- Oil
vim.keymap.set("n", "<leader>pv", vim.cmd.Oil, { desc = "Open Files (oil.nvim)" })

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

---Change a camelCase string to a snake_case string
---@param s string
---@return string
local function to_snake_case(s)
    if s:find("_", nil, true) then
        return s
    end
    ---@type table<integer, string>[]
    local chars = vim.fn.items(s)
    local buf = buffer.new(#s)
    for _, pair in ipairs(chars) do
        ---@type integer, string
        local i, char = unpack(pair)
        if i > 1 and char:upper() == char then
            buf:put("_", char:lower())
        else
            buf:put(char)
        end
    end
    return buf:get()
end
vim.keymap.set("v", "<S-s>", function()
    local _, start_line, start_col = unpack(vim.fn.getpos("v"))
    local _, end_line, end_col = unpack(vim.fn.getpos("."))
    --Indexing is 0 based, so adjust accordingly
    --End col is exclusive, everything else inclusive
    if start_line ~= end_line then
        vim.notify("Cannot operate over multiple lines", vim.log.levels.ERROR)
        return
    end

    if start_col > end_col then
        start_col, end_col = end_col, start_col
    end
    local s = vim.api.nvim_buf_get_text(0, start_line - 1, start_col - 1, end_line - 1, end_col, {})[1]
    vim.api.nvim_buf_set_text(0, start_line - 1, start_col - 1, end_line - 1, end_col, { to_snake_case(s) })

    local key = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
    vim.api.nvim_feedkeys(key, "n", false)
end, { desc = "[S]nake case" })

return {}
