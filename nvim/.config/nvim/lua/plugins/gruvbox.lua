return {
	"ellisonleao/gruvbox.nvim",
	priority = 1000,
	config = function(plugin)
    local gruvbox = require('gruvbox')

    gruvbox.setup()

    --vim.cmd.colorscheme('gruvbox')
  end,
}
