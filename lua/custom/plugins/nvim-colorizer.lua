return {
    {
        "norcalli/nvim-colorizer.lua",
        opts = {
            RRGGBBAA = true,
        },
        config = function(_, opts)
            require("colorizer").setup({ "*" }, opts)
        end,
    },
}
