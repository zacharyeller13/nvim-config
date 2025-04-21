---Replaces `[toc]` in a markdown file
local function replace_toc(_)
    -- TOC probably never more than 10 lines down
    local lines = vim.api.nvim_buf_get_lines(0, 0, 10, false)

    for idx, line in pairs(lines) do
        if line == "[toc]" then
            vim.api.nvim_buf_set_lines(0, idx - 1, idx, false, { "<!-- mtoc-start -->", "<!-- mtoc-end -->" })
            vim.cmd.Mtoc()
            return
        end
    end
end

---Formats a markdown table in visual mode and then returns to normal mode
---Thanks to https://heitorpb.github.io/bla/format-tables-in-vim/
---for the explanation of using `tr` and `column`
---@param args table? A table of user-command arguments if called from a user-command
local function format_table(args)
    local start = args and args.line1 or vim.fn.getpos("v")[2]
    local end_idx = args and args.line2 or vim.fn.getpos(".")[2]

    -- If it's a reverse range selection
    if start > end_idx then
        start, end_idx = end_idx, start
    end
    vim.api.nvim_cmd({ range = { start, end_idx }, cmd = "!", args = { "tr -s ' ' | column -t -s '|' -o '|'" } }, {})

    local key = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
    vim.api.nvim_feedkeys(key, "v", false)
end

vim.api.nvim_buf_create_user_command(
    0,
    "ReplaceToc",
    replace_toc,
    { desc = "Finds and replaces '[toc]' in markdown file" }
)

vim.api.nvim_buf_create_user_command(0, "FormatTable", format_table, { desc = "Formats markdown table", range = true })

-- Kemaps
local map = vim.keymap.set
local opts = { noremap = true, silent = true, buffer = true, desc = "Markdown TOC" }
map("n", "<leader>md", vim.cmd.Mtoc, opts)
opts = vim.tbl_extend("force", opts, { desc = "Replace [TOC]" })
map("n", "<leader>toc", vim.cmd.ReplaceToc, opts)

--
map("v", "<leader>f", format_table, { buffer = true, desc = "[F]ormat markdown table" })
