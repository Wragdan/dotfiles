return {
	"stevearc/oil.nvim",
	config = function()
		require("oil").setup({
			view_options = {
				show_hidden = true,
			},
			keymaps = {
				["<C-w>"] = { "actions.parent", mode = "n" },
			},
		})

		vim.keymap.set("n", "sf", "<CMD>Oil --float<CR>", { desc = "Open parent directory" })
	end,
	dependencies = { { "echasnovski/mini.icons", opts = {} } },
	lazy = false,
}
