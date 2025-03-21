local M = {}

-- vim.ui.input({ prompt = "Hello? " }, function(input)
--     if input then
--         vim.print(input)
--     end
-- end)
--
vim.cmd("vsplit +term")
vim.cmd("split +term")
vim.print(vim.api.nvim_list_bufs())
vim.print(vim.api.nvim_list_wins())

for _, value in pairs(vim.api.nvim_list_chans()) do
    vim.print(value.id)
    vim.print(value.mode)
end

return M
