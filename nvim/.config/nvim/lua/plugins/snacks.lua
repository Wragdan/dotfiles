return {
	"folke/snacks.nvim",
	dependencies = {
		"Juksuu/worktrees.nvim",
	},
	keys = {
		{
			";q",
			function()
				Snacks.picker.projects()
			end,
			desc = "Grep",
		},
		{
			"fr",
			function()
				Snacks.picker.grep({
					hidden = true,
					ignored = false,
				})
			end,
			desc = "Grep",
		},
		{
			"ff",
			function()
				Snacks.picker.files({
					finder = "files",
					format = "file",
					hidden = true,
					ignored = false,
					show_empty = true,
					supports_live = true,
					win = {
						input = {
							keys = {
								[";a"] = { "explorer_add", mode = { "i", "n" } },
								[";d"] = { "explorer_del", mode = { "i", "n" } },
								[";r"] = { "explorer_rename", mode = { "i", "n" } },
							},
						},
					},
				})
			end,
			desc = "Find all files not ignored",
		},
		{
			"fa",
			function()
				Snacks.picker.files({
					finder = "files",
					format = "file",
					hidden = true,
					ignored = true,
					show_empty = true,
					supports_live = true,
					win = {
						input = {
							keys = {
								[";a"] = { "explorer_add", mode = { "i", "n" } },
								[";d"] = { "explorer_del", mode = { "i", "n" } },
								[";r"] = { "explorer_rename", mode = { "i", "n" } },
							},
						},
					},
				})
			end,
			desc = "Find al files include ignored",
		},
		{
			"<leader>b",
			function()
				Snacks.picker.buffers()
			end,
			desc = "Show all buffers",
		},
		{
			";t",
			function()
				Snacks.picker.help()
			end,
			desc = "Show all help tags",
		},
		{
			";e",
			function()
				Snacks.picker.diagnostics()
			end,
			desc = "Show all diagnostics",
		},
		{
			";b",
			function()
				Snacks.picker.git_branches()
			end,
			desc = "Show all git branches",
		},
    { "<leader>gi", function() Snacks.picker.gh_issue() end, desc = "GitHub Issues (open)" },
    { "<leader>gI", function() Snacks.picker.gh_issue({ state = "all" }) end, desc = "GitHub Issues (all)" },
    { "<leader>gp", function() Snacks.picker.gh_pr() end, desc = "GitHub Pull Requests (open)" },
    { "<leader>gP", function() Snacks.picker.gh_pr({ state = "all" }) end, desc = "GitHub Pull Requests (all)" },
	},
	---@type snacks.Config
	opts = {
		explorer = {
			replace_netrw = true, -- Replace netrw with the snacks explorer
			-- your explorer configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
	},
}
