---@module "fff.picker_ui"
-- local picker_ui = require("fff.picker_ui")

---@module "fff.picker_ui.picker_ui"
local picker_ui = require("fff.picker_ui.picker_ui")

---Transform picker_ui.filtered_items into a list of relative paths
---@param filtered_items table[]?
---@return string[]
local function relative_paths(filtered_items)
    local ret = {}
    if not filtered_items then
        return ret
    end
    for _, item in ipairs(filtered_items) do
        table.insert(ret, item.relative_path)
    end
    return ret
end

-- This is just for file search
vim.keymap.set({ "n", "i" }, "<C-y>", function()
    if picker_ui.state.mode == "grep" then
        picker_ui.close()
        return
    end
    local harpoon = require("harpoon")
    -- If nothing is selected then just grab the filtered set
    -- otherwise we want only what's been selected
    local selected = picker_ui.state.selected_files
    local filtered_items = picker_ui.state.filtered_items
    local items = vim.tbl_keys(selected)
    if #items == 0 then
        items = relative_paths(filtered_items)
    end
    if #items == 0 then
        vim.notify("[fff-harpoon] no items for this picker", vim.log.levels.ERROR)
        picker_ui.close()
        return
    end
    for _, item in ipairs(items) do
        local list = harpoon:list()
        local harpoon_item = list.config.create_list_item(list.config, item)
        harpoon:list():add(harpoon_item)
    end
    picker_ui.close()
end, { buf = picker_ui.state.input_buf })
