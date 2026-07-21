-- Run python code in a new terminal
-- vim.keymap.set('n', '<space><space>x', '<cmd>term python3 %<CR>')

local term = require("custom.term").new()

term.callback = function()
    term:send({ "uv run python\n" })
end

vim.keymap.set("n", "<space><space>t", function()
    term:create_term()
end, { buffer = true, desc = "Spawn [T]erminal" })

-- k is for kallback
vim.keymap.set("n", "<space>k", function()
    term.callback()
end, { buffer = true, desc = "Fire Terminal Callback" })

vim.keymap.set("v", "<space><space>x", function()
    local start = vim.fn.getpos("v")[2]
    local end_idx = vim.fn.getpos(".")[2]

    if start > end_idx then
        start, end_idx = end_idx, start
    end
    local com = vim.api.nvim_buf_get_lines(0, start - 1, end_idx, true)
    vim.print(com)

    local out = {}
    local indent = 0
    for i, line in ipairs(com) do
        -- Find how indented
        if i == 1 then
            local spaces = line:match("^ +")
            if spaces then
                indent = #spaces
                vim.notify("len spaces: " .. tostring(indent), vim.log.levels.INFO)
            end
        end
        -- trim off indent
        table.insert(out, line:sub(indent + 1))
    end

    -- com, _ = com:gsub("^ +", "")
    term:send(out)
end, { buffer = true })

vim.keymap.set("n", "<space>t", function()
    term:toggle()
end, { desc = "Open [T]erminal" })
