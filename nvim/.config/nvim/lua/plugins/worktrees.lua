return {
	"Juksuu/worktrees.nvim",
	dependencies = {
		"plenary",
		"folke/snacks.nvim",
	},
	config = function()
		local wt = require("worktrees")
		wt.setup()

    vim.keymap.set("n", "sw", Snacks.picker.worktrees)
    vim.keymap.set("n", "<leader>wn", Snacks.picker.worktrees_new)
    vim.keymap.set("n", "<leader>wr", Snacks.picker.worktrees_remove)
	end,
}
