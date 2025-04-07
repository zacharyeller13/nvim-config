-- Run python code in a new terminal
-- vim.keymap.set('n', '<space><space>x', '<cmd>term python3 %<CR>')

local repl = require("custom.dev")

repl.callback = function()
    repl:send("uv run python\n")
end

local com = "     print('hello world')\n"

vim.keymap.set("n", "<space><space>t", function()
    repl:create_term()
end, { buffer = true })

vim.keymap.set("n", "<space><space>x", function()
    com, _ = com:gsub("^ +", "")
    repl:send(com)
end, { buffer = true })

vim.keymap.set("n", "<space>t", function()
    repl:toggle()
end)
