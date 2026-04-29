local function pack_clean()
	local active_plugins = {}
	local unused_plugins = {}

	for _, plugin in ipairs(vim.pack.get()) do
		active_plugins[plugin.spec.name] = plugin.active
	end

	for _, plugin in ipairs(vim.pack.get()) do
		if not active_plugins[plugin.spec.name] then
			table.insert(unused_plugins, plugin.spec.name)
		end
	end

	if #unused_plugins == 0 then
		print("No unused plugins.")
		return
	end

	local choice = vim.fn.confirm("Remove unused plugins?", "&Yes\n&No", 2)
	if choice == 1 then
		vim.pack.del(unused_plugins)
	end
end

vim.keymap.set("n", "<leader>pc", pack_clean)

vim.pack.add({
	{ src = "https://github.com/catppuccin/nvim", version = "main" },
	-- oil
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	-- diagnostics
	{ src = "https://github.com/rachartier/tiny-inline-diagnostic.nvim" },
	-- fugitive
	{ src = "https://github.com/tpope/vim-fugitive" },
	-- gitsigns
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	-- fzf-lua
	{ src = "https://github.com/ibhagwan/fzf-lua" },
	-- formatter
	{ src = "https://github.com/stevearc/conform.nvim" },
	-- mason
	{ src = "https://github.com/williamboman/mason.nvim" },
	-- snippets
	-- cd ~/.config/nvim/pack/plugins/start/LuaSnip
	-- make install_jsregexp
	{ src = "https://github.com/rafamadriz/friendly-snippets" },
	{ src = "https://github.com/L3MON4D3/LuaSnip" },
	-- surround
	{ src = "https://github.com/tpope/vim-surround" },
	-- treesitter
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "90cd658" },
	-- autocomplete
	{ src = "https://github.com/saghen/blink.cmp", version = "v1" },
	-- undotree
	{ src = "https://github.com/mbbill/undotree" },
})
