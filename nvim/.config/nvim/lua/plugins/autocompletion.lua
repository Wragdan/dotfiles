return {
	"saghen/blink.cmp",
	version = "1.*",
	dependencies = { "rafamadriz/friendly-snippets" },

	config = function()
		require("blink.cmp").setup({
			signature = { enabled = true },
      keymap = { preset = 'enter' },
			completion = {
				documentation = { auto_show = true, auto_show_delay_ms = 500 },
				menu = {
					auto_show = false,
					draw = {
						treesitter = { "lsp" },
						columns = { { "kind_icon", "label", "label_description", gap = 1 }, { "kind" } },
					},
				},
			},
		})
	end,
}
