if vim.fn.executable("dotnet") == 1 then
    return {
        "seblyng/roslyn.nvim",
        ft = "cs",
        ---@module 'roslyn.config'
        ---@type RoslynNvimConfig
        opts = {
            choose_target = function(target)
                return vim.iter(target):find(function(item)
                    if item:match("slnx") then
                        return item
                    end
                end)
            end,
        },
    }
else
    return {}
end
