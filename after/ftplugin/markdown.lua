---Replaces `[toc]` in a markdown file
---@param args table table of arguments
local function replace_toc(args)
    -- TOC probably never more than 10 lines down
    -- print(vim.inspect(args))
    local lines = vim.api.nvim_buf_get_lines(0, 0, 10, false)

    for idx, line in pairs(lines) do
        -- print(key, value)
        if line == '[toc]' then
            vim.api.nvim_buf_set_lines(0, idx - 1, idx, false, { '<!-- mtoc-start -->', '<!-- mtoc-end -->' })
            vim.cmd.Mtoc()
            -- Early return a little bit
            return
        end
    end
end

---Formats a markdown table in visual mode and then returns to normal mode
---Thanks to https://heitorpb.github.io/bla/format-tables-in-vim/
local function format_table()
    local start = vim.fn.getpos('v')
    vim.print('start: ', start)
    local end_idx = vim.fn.getpos('.')
    vim.print('end: ', end_idx)
    vim.api.nvim_cmd(
        { range = { start[2], end_idx[2] }, cmd = '!', args = { 'column', '-t', '-s', "'|'", '-o', "'|'" } },
        {}
    )
    local key = vim.api.nvim_replace_termcodes('<Esc>', true, false, true)
    vim.api.nvim_feedkeys(key, 'v', false)
end

vim.api.nvim_buf_create_user_command(
    0,
    'ReplaceToc',
    replace_toc,
    { desc = "Finds and replaces '[toc]' in markdown file" }
)

-- Kemaps
local map = vim.keymap.set
local opts = { noremap = true, silent = true, buffer = true, desc = 'Markdown TOC' }
map('n', '<leader>md', vim.cmd.Mtoc, opts)
opts = vim.tbl_extend('force', opts, { desc = 'Replace [TOC]' })
map('n', '<leader>toc', vim.cmd.ReplaceToc, opts)

map('v', '<leader>f', format_table, { desc = '[F]ormat markdown table' })
