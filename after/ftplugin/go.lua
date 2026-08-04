local term = require("custom.term")
term.instances.golang = term.instances.golang or term.new()

local inst = term.instances.golang

inst.callback = function()
    inst:send({ "source .env\n" })
end

vim.keymap.set("n", "<space><space>t", function()
    inst:create_term()
end, { buffer = true })

-- k is for kallback
vim.keymap.set("n", "<space>k", function()
    inst.callback()
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
    inst:send(com)
end, { buffer = true })

vim.keymap.set("n", "<space>t", function()
    inst:toggle()
end)
