-- Run python code in a new terminal
-- vim.keymap.set('n', '<space><space>x', '<cmd>term python3 %<CR>')

local repl = require('custom.dev')

local com = "print('hello world')\n"

vim.keymap.set('n', '<space><space>t', function()
    repl:create_term()
end)
vim.keymap.set('n', '<space><space>x', function()
    repl:send(com)
end)
