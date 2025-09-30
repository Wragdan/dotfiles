return {
	"stevearc/oil.nvim",
	config = function()
		require("oil").setup({
			view_options = {
				show_hidden = true,
			},
			keymaps = {
				["<C-w>"] = { "actions.parent", mode = "n" },
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = { "actions.close", mode = "n" },
			},
		})

		vim.keymap.set("n", "sf", "<CMD>Oil --float<CR>")
	end,
	dependencies = { { "echasnovski/mini.icons", opts = {} } },
	lazy = false,
}
