return {
	"folke/snacks.nvim",
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
          ignored = false
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
		--{
		--	"sf",
		--	function()
		--		local function telescope_buffer_dir()
		--			return vim.fn.expand("%:p:h")
		--		end

		--		local cwd = telescope_buffer_dir()

		--		local sp = require("snacks.picker")
		--		sp.files({
		--			cwd = cwd,
		--			cmd = "fd",
		--			args = { "--hidden", "--follow", "--max-depth", "1", "--type", "d", "--type", "f" },
		--			actions = {
		--				confirm = {
		--					action = function(picker, selected)
    --            --print(selected.file)
		--						local file = cwd .. "/" .. selected.file

		--						-- If the selection is a directory recurse otherwise open the file
		--						if vim.fn.isdirectory(file) ~= 0 then
		--							file = file:sub(1, #file - 1) -- Trim trailing slash if it's a directory
		--							cwd = file
		--							picker:set_cwd(file)
		--							picker.input:set("", "")
		--							picker:find()
		--						else
		--							picker:close()
		--							vim.cmd.edit(file)
		--						end
		--					end,
		--				},
		--				parent = {
		--					action = function(picker, selected)
		--						cwd = vim.loop.fs_realpath(cwd .. "/..")
		--						picker:set_cwd(cwd)
		--						picker:find()
		--					end,
		--				},
		--				cd = {
		--					action = function(picker, selected)
		--						cwd = vim.loop.fs_realpath(cwd .. "/" .. selected.file)
		--						vim.cmd("tcd " .. cwd)
		--						picker:find()
		--					end,
		--				},
		--			},
		--			win = {
		--				input = {
		--					keys = {
		--						["<c-w>"] = { "parent", mode = { "i", "n" } },
		--						["<m-c>"] = { "cd", mode = { "i", "n" } },
		--						[";a"] = { "explorer_add", mode = { "i", "n" } },
		--						[";d"] = { "explorer_del", mode = { "i", "n" } },
		--						[";r"] = { "explorer_rename", mode = { "i", "n" } },
		--					},
		--				},
		--			},
		--		})
		--	end,
		--	desc = "Grep",
		--},
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
