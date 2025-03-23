local M = {
    ---@type integer?
    chan = nil,
}
M.__index = M

---Send a command to the open terminal channel
---@param cmd string
function M:send(cmd)
    if cmd:sub(-1) ~= '\n' then
        cmd = cmd .. '\n'
    end
    if self.chan then
        vim.api.nvim_chan_send(self.chan, cmd)
    else
        vim.print('No open terminal')
    end
end

---Create a new terminal buffer in a vertical split
---@param split_dir
---| 'vsplit'
---| 'split'
function M:create_term(split_dir)
    local splits = { 'vsplit', 'split' }
    if not vim.tbl_contains(splits, split_dir, opts?)

    local ok, err = pcall(vim.api.nvim_cmd, { cmd = split_dir }, {})
    if not ok then
        vim.print(ok, err)
    else
        vim.api.nvim_cmd({ cmd = 'terminal' }, {})
        self.chan = vim.b.terminal_job_id
    end
end

return M
