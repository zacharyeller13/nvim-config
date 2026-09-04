return {
    {
        "hedyhli/markdown-toc.nvim",
        ft = "markdown", -- Lazy load on markdown filetype
        cmd = { "Mtoc" }, -- Or, lazy load on "Mtoc" command
        opts = {
            auto_update = true,
        },
    },
    {
        "MeanderingProgrammer/render-markdown.nvim",
        -- dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
        -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
        dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
        ---@module 'render-markdown'
        ---@type render.md.UserConfig
        opts = { file_types = { "markdown", "codecompanion", "joplin.markdown" }, latex = { enabled = false } },
        ft = { "markdown", "codecompanion", "joplin.markdown" },
    },
}
