return {
  "nvim-treesitter/nvim-treesitter",
  config = function()
    local configs = require('nvim-treesitter.configs')

    configs.setup({
      ensure_installed = { "lua", "vim", "vimdoc", "javascript", "typescript", "c", "rust" },
      auto_install = true,
      sync_install = false,
      highlight = { enable = true },
      indent = { enable = true },
    })
  end,
  dependencies = {
    -- NOTE: additional parser
    { "nushell/tree-sitter-nu",      build = ":TSUpdate nu" },
    { "rayliwell/tree-sitter-rstml", build = ":TSUpdate rshtml" },
  },
  build = ":TSUpdate",
}
