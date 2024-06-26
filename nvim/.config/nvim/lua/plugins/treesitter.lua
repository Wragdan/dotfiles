return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local configs = require('nvim-treesitter.configs')

        configs.setup({
            ensure_installed = { "astro", "css", "lua", "vim", "vimdoc", "javascript", "typescript", "terraform", "hcl",
                "html", "http", "json", "yaml" },
            auto_install = true,
            sync_install = false,
            highlight = { enable = true },
            indent = { enable = true },
        })
    end
}
