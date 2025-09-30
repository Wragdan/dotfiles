return {
	"nvim-treesitter/nvim-treesitter",
	branch = "master",
	lazy = false,
	config = function()
		local ts = require("nvim-treesitter")
		local configs = require("nvim-treesitter.configs")

		configs.setup({
			ignore_install = { "dockerfile" },
			ensure_installed = { "lua" },
			auto_install = true,
			sync_install = false,
			highlight = { enable = true, use_languagetool = true, additional_vim_regex_highlighting = false },
			indent = { enable = true },
		})

		--vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
		--	pattern = { "dockerfile" },
		--	command = [[ TSDisable ]],
		--})
	end,
	dependencies = {
		-- NOTE: additional parser
		--{ "nushell/tree-sitter-nu",      build = ":TSUpdate nu" },
		--{ "rayliwell/tree-sitter-rstml", build = ":TSUpdate rshtml" },
	},
	build = ":TSUpdate",
}
