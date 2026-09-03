---Extension method to check that string s starts with a substring
---
---```lua
---local s = "foobar"
---assert s:startswith("foo")
---
---@see vim.startswith
---@param s string
---@param prefix string
---@return boolean
function string.startswith(s, prefix)
    return vim.startswith(s, prefix)
end
