---Extension method to check that string s starts with a substring
---@param s string
---@param start string
---@return boolean
function string.starts(s, start)
    return string.sub(s, 1, string.len(start)) == start
end
