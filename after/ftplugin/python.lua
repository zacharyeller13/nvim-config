-- Run python code in a new terminal
-- vim.keymap.set('n', '<space><space>x', '<cmd>term python3 %<CR>')

local term = require("custom.term")

term.callback = function()
    term:send("uv run python\n")
end

vim.keymap.set("n", "<space><space>t", function()
    term:create_term()
end, { buffer = true })

vim.keymap.set("v", "<space><space>x", function()
    local start = vim.fn.getpos("v")[2] - 1
    local end_idx = vim.fn.getpos(".")[2]
    local com = vim.api.nvim_buf_get_lines(0, start, end_idx, true)
    vim.print(com)

    -- com, _ = com:gsub("^ +", "")
    -- term:send(com)
end, { buffer = true })

vim.keymap.set("n", "<space>t", function()
    term:toggle()
end)
