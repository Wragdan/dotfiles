return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = true,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		dependencies = {
			{ "williamboman/mason.nvim" },
		},
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
				},
				handlers = {
					function(server_name)
						lsp_config[server_name].setup({})
					end,
				},
				--  tinymist = function()
				--    lsp_config.tinymist.setup({
				--      offset_encoding = "utf-8",
				--      settings = {
				--        formatterMode = "typstyle",
				--        exportPdf = "onSave",
				--        --semanticTokens = "disable"
				--      }
				--    })
				--  end,
				--  denols = function()
				--    lsp_config.denols.setup({ root_dir = lsp_config.util.root_pattern("deno.json", "deno.jsonc"), single_file_support = false })
				--  end,
				--  ts_ls = function()
				--    lsp_config.ts_ls.setup({ root_dir = lsp_config.util.root_pattern("package.json"), single_file_support = false })
				--  end,
				--  rust_analyzer = function()
				--    lsp_config.rust_analyzer.setup({
				--      cmd = { "rust-analyzer" },
				--      settings = {
				--        ["rust-analyzer"] = {
				--          checkOnSave = {
				--            command = "clippy",
				--            extraArgs = { "--target-dir=./target/check" },
				--          },
				--        },
				--      }
				--    })
				--  end,
				--  html = function()
				--    lsp_config.html.setup({ filetypes = { 'html', 'templ' } })
				--  end,
				--  htmx = function()
				--    lsp_config.htmx.setup({ filetypes = { 'html', 'templ', 'rust', 'htmldjango' } })
				--  end,
				--  tailwindcss = function()
				--    lsp_config.tailwindcss.setup({ filetypes = { 'html', 'templ', 'javascript', 'typescript', 'typescriptreact', 'react', 'rust' }, init_options = { userLanguages = { templ = "html", rust = "html" } }, })
				--  end,
				--  lua_ls = function()
				--    local lua_opts = lsp_zero.nvim_lua_ls()
				--    lsp_config.lua_ls.setup(lua_opts)
				--    --vim.filetype.add({ extension = { templ = "templ" } })
				--  end,
				--  nil_ls = function()
				--    lsp_config.nil_ls.setup({
				--      settings = {
				--        ['nil'] = {
				--          formatting = {
				--            command = { "nixfmt" },
				--          },
				--        },
				--      },
				--    })
				--  end
				--}
			})
		end,
	},
}
