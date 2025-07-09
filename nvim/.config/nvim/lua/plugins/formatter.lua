return {
	"stevearc/conform.nvim",
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				--rust = { "rustfmt", lsp_format = "fallback" },
				lua = { "stylua" },
				typescriptreact = { "biome-check", stop_after_first = true },
				typescript = { "biome-check", stop_after_first = true },
        rust = { "rustfmt", lsp_format = "fallback" },
			},
			--format_on_save = {
			--  -- These options will be passed to conform.format()
			--  timeout_ms = 10000,
			--  lsp_format = "fallback",
			--  async = false
			--},
		})
	end,
}
