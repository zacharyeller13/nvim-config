---@type LazyPluginSpec
local M = { -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    branch = "main",
    init = function()
        require("nvim-treesitter").setup({
            -- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
            install_dir = vim.fn.stdpath("data") .. "/site",
        })
        local ensure_installed = {
            "hurl",
            "bash",
            "python",
            "c",
            "diff",
            "groovy",
            "go",
            "html",
            "json",
            "lua",
            "markdown",
            "markdown_inline",
            "sql",
            "vim",
            "vimdoc",
            "xml",
            "yaml",
        }
        -- Per docs this is a no-op if all are already installed so should be fine to not have to filter
        -- Or check if they're installed
        require("nvim-treesitter").install(ensure_installed)

        -- This list isn't going to change often enough to have to get it inside the autocmd
        local available = require("nvim-treesitter").get_available()

        vim.api.nvim_create_autocmd("FileType", {
            callback = function(ev)
                -- Auto-install
                if vim.tbl_contains(available, ev.match) and not vim.tbl_contains(ensure_installed, ev.match) then
                    require("nvim-treesitter").install(ev.match)
                end

                -- highlight yes
                -- This needs to not throw errors for "invalid" filetypes (e.g. 'fidget', 'harpoon', etc.)
                pcall(vim.treesitter.start)
                -- indent yes
                vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end,
            desc = "Enable Nvim-Treesitter features",
        })
    end,
}

return M
