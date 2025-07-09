return {
	"tpope/vim-fugitive",
	event = "VeryLazy",
	cmd = { "Git", "Gwrite", "Gdiffsplit", "Gvdiffsplit" },
	keys = {
		{
			"<leader>gs",
			function()
				vim.cmd.Git()
			end,
			desc = "Open git status / fugitive",
		},
		{
			"<leader>P",
			function()
				vim.cmd.Git("pull --rebase")
			end,
			desc = "Git pull --rebase",
		},
		{
			"<leader>p",
			function()
				vim.cmd.Git("pull push")
			end,
			desc = "Git push",
		},
	},
}
