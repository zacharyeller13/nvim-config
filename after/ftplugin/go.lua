local term = require("custom.term").new()

term.callback = function()
    term:send({ "source .env\n" })
end

vim.keymap.set("n", "<space><space>t", function()
    term:create_term()
end, { buffer = true })

-- k is for kallback
vim.keymap.set("n", "<space>k", function()
    term.callback()
end, { buffer = true })

vim.keymap.set("v", "<space><space>x", function()
    local start = vim.fn.getpos("v")[2]
    local end_idx = vim.fn.getpos(".")[2]

    if start > end_idx then
        start, end_idx = end_idx, start
    end
    local com = vim.api.nvim_buf_get_lines(0, start - 1, end_idx, true)
    vim.print(com)

    -- com, _ = com:gsub("^ +", "")
    term:send(com)
end, { buffer = true })

vim.keymap.set("n", "<space>t", function()
    term:toggle()
end)
