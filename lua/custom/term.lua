---@class TerminalState
---Currently open terminal channel
---@field chan integer?
---Terminal buffer number
---@field bufnr integer?
---Direction for the terminal split
---@field split_dir
---| 'left'
---| 'right'
---| 'above'
---| 'below'
---Callback to run when opening a new terminal
---@field callback function
local M = {
    chan = nil,
    bufnr = nil,
    split_dir = "right",
    callback = function() end,
}
M.__index = M

---Send a command to the open terminal channel
---@param cmds string[]
function M:send(cmds)
    if not self.chan then
        vim.notify("No open terminal", vim.log.levels.INFO)
        return
    end

    for _, cmd in ipairs(cmds) do
        vim.api.nvim_chan_send(self.chan, cmd .. "\n")
    end
end

---Create a new terminal buffer in a split
---@param split_dir? - The direction in which to open a new split
---| 'left'
---| 'right'
---| 'above'
---| 'below'
function M:create_term(split_dir)
    local splits = { "left", "right", "above", "below" }
    if not split_dir then
        split_dir = "right"
    end
    if not vim.list_contains(splits, split_dir) then
        vim.notify("split_dir must be one of " .. vim.fn.join(splits, ", "), vim.log.levels.ERROR)
    end

    self.split_dir = split_dir

    if self.chan and not vim.tbl_isempty(vim.api.nvim_get_chan_info(self.chan)) then
        vim.notify("Terminal already running, opening", vim.log.levels.WARN)
        self:toggle()
        return
    end

    -- First open a split, then open a term in that split
    local ok, result = pcall(vim.api.nvim_open_win, 0, true, { split = split_dir })
    if not ok then
        vim.notify("Error: " .. result, vim.log.levels.WARN)
    else
        vim.api.nvim_cmd({ cmd = "terminal" }, {})
        self.chan = vim.b.terminal_job_id
        -- self.callback()
    end
end

---Toggles an existing terminal buffer/window
function M:toggle()
    if not self.chan then
        vim.notify("No open terminal", vim.log.levels.INFO)
        return
    end

    if not self.bufnr then
        self.bufnr = self._find_bufnr(self.chan)
    end

    if not self.bufnr then
        vim.notify("No open terminal", vim.log.levels.INFO)
        return
    end

    -- Hide term
    local winnr = vim.fn.bufwinid(self.bufnr)
    if winnr ~= -1 then
        vim.api.nvim_win_hide(winnr)
        return
    end

    -- Occasionally the terminal buffer is not getting fully cleaned up
    -- So we can double check that it does actually still exist
    if not vim.fn.bufexists(self.bufnr) then
        vim.notify("Terminal buffer has already been closed", vim.log.levels.WARN)
        self.bufnr = nil
        return
    end

    -- Unhide term
    vim.api.nvim_open_win(self.bufnr, true, { split = self.split_dir })
end

---Find the buffer number for a given channel
---@param chan_nr integer The channel number for which to find a related buffer
---@return integer?
function M._find_bufnr(chan_nr)
    local channels = vim.api.nvim_list_chans()
    for _, chan in ipairs(channels) do
        if chan.id == chan_nr then
            return chan.buffer
        end
    end
    return nil
end

return M
