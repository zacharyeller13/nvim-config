---@class DevOps
---@field state table<string,boolean>
local M = {
    state = {},
}
M.__index = M

---@param target string
---@return string[]
function M.diff_files(target)
    local files = vim.system({ "git", "diff", "--name-only", target }):wait()
    if files.code ~= 0 then
        error(("error getting git diff: %s"):format(files.stderr), vim.log.levels.ERROR)
    end
    return vim.split(files.stdout, "\n", { trimempty = true })
end

---@param path string
---@param reviewed boolean
function M:set_reviewed(path, reviewed)
    self.state[path] = reviewed
end

---@param path string
---@return boolean
function M:is_reviewed(path)
    return self.state[path] or false
end

---@param tbl table<string,boolean>
---@return Iterator<string,boolean>
local function sorted(tbl)
    local keys = vim.tbl_keys(tbl)
    table.sort(keys)
    local i = 0
    local iter = function()
        i = i + 1
        if keys[i] == nil then
            return nil
        else
            return keys[i], tbl[keys[i]]
        end
    end
    return iter
end

function M:to_qflist()
    ---@type vim.quickfix.entry[]
    local qf = {}
    for key, val in sorted(self.state) do
        local mark = val and "[✓]" or "[ ]"
        table.insert(qf, { filename = key, text = mark })
    end
    vim.fn.setqflist(qf, "u")
    vim.cmd.copen()
end

---@param target string
---@return integer # count of reviewed files
---@return integer # count of all files in diff
---@return string[] # filenames in diff
function M:status(target)
    local files = M.diff_files(target)
    local reviewed = 0
    for _, f in ipairs(files) do
        if self.state[f] then
            reviewed = reviewed + 1
        end
    end
    return reviewed, #files, files
end

---@return string[] #git branches
local function branches_for_completion()
    local out = vim.system({ "git", "branch", "-l", "--format=%(refname:short)" }):wait()
    return vim.split(out.stdout, "\n", { trimempty = true })
end

function M.setup()
    vim.api.nvim_create_user_command("DevOpsFiles", function(args)
        local files = M.diff_files(args.args)
        ---@type vim.quickfix.entry[]
        local qf = {}
        for _, f in ipairs(files) do
            local mark = M.state[f] and "[✓]" or "[ ]"
            table.insert(qf, { filename = f, text = mark })

            M.state[f] = M.state[f] or false
        end
        vim.fn.setqflist(qf, "u")
        local win = vim.api.nvim_tabpage_get_win(0)
        vim.cmd.copen()
        vim.api.nvim_tabpage_set_win(0, win)
    end, { nargs = 1, complete = branches_for_completion })

    vim.api.nvim_create_user_command("DevOpsToggle", function()
        local path = vim.fn.expand("%:.")
        if not vim.tbl_contains(vim.tbl_keys(M.state), path) then
            return
        end
        M:set_reviewed(path, not M:is_reviewed(path))
        local win = vim.api.nvim_tabpage_get_win(0)
        M:to_qflist()
        vim.api.nvim_tabpage_set_win(0, win)
    end, {})

    vim.keymap.set("n", "<leader>,", vim.cmd.DevOpsToggle, { desc = "DevOpsToggle current file" })
end

return M
