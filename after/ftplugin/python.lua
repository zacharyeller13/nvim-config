-- Run python code in a new terminal
-- vim.keymap.set('n', '<space><space>x', '<cmd>term python3 %<CR>')

local term = require("custom.term")

term.callback = function()
    term:send("uv run python\n")
end

local com = "     print('hello world')\n"

vim.keymap.set("n", "<space><space>t", function()
    term:create_term()
end, { buffer = true })

vim.keymap.set("n", "<space><space>x", function()
    com, _ = com:gsub("^ +", "")
    term:send(com)
end, { buffer = true })

vim.keymap.set("n", "<space>t", function()
    term:toggle()
end)
