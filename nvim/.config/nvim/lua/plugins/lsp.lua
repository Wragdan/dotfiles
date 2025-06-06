return {
  {
    'VonHeikemen/lsp-zero.nvim',
    dependencies = {
      { 'neovim/nvim-lspconfig' },
      {
        'williamboman/mason.nvim',
        lazy = false,
        config = true,
      },
      { 'L3MON4D3/LuaSnip' },
      { 'hrsh7th/nvim-cmp' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
      { 'saadparwaiz1/cmp_luasnip' },
      { 'rafamadriz/friendly-snippets' },
    },
    branch = 'v3.x',
    lazy = true,
    config = function()
      local lsp_zero = require('lsp-zero')

      lsp_zero.on_attach(function(_, bufnr)
        lsp_zero.default_keymaps({ buffer = bufnr })

        lsp_zero.default_keymaps({ buffer = bufnr, preserve_mappings = true })

        local opts = { buffer = bufnr }
        local bind = vim.keymap.set

        bind('n', 'gd', function() vim.lsp.buf.definition() end, opts)
        bind('n', '<leader>f',
          function() vim.lsp.buf.format({ async = false, timeout_ms = 10000 }) end, opts)
        bind('n', ';d', function() vim.diagnostic.open_float() end, opts)
        bind('n', '<leader>rn', function() vim.lsp.buf.rename() end, opts)
        bind('n', '<leader>ca', function() vim.lsp.buf.code_action() end, opts)
        bind('n', '<leader>rr', function() vim.lsp.buf.references() end, opts)
        bind('n', ']d', function() vim.diagnostic.goto_next() end, opts)
        bind('n', '[d', function() vim.diagnostic.goto_prev() end, opts)
        bind('i', '<C-h>', function() vim.lsp.buf.signature_help() end, opts)
      end)

      local cmp = require('cmp')
      --local cmp_action = require('lsp-zero').cmp_action()

      require('luasnip.loaders.from_vscode').lazy_load()

      cmp.setup({
        sources = {
          { name = 'path' },
          { name = 'nvim_lsp' },
          { name = 'luasnip', keyword_length = 2 },
          { name = 'buffer',  keyword_length = 3 },
        },
        formatting = lsp_zero.cmp_format(),
        mapping = cmp.mapping.preset.insert({
          ['<CR>'] = cmp.mapping.confirm({ select = false }),
          ['<C-Space>'] = cmp.mapping.complete(),
          --['<Tab>'] = cmp_action.luasnip_supertab(),
          --['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
        }),
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
      })

      lsp_zero.format_on_save({
        format_opts = {
          async = false,
          timeout_ms = 10000,
        },
        servers = {
          ['lua_ls'] = { 'lua' },
          ['rust_analyzer'] = { 'rust' },
          ['gopls'] = { 'go' },
        }
      })

      lsp_zero.configure('rust_analyzer', {
        settings = {
          ["rust-analyzer"] = {
            inlayHints = {
              enable = true,
              typeHints = true,
              parameterHints = true,
            },
            checkOnSave = {
              command = "clippy",
              extraArgs = { "--target-dir=./target/check" },
              allFeatures = true,
            },
            cargo = {
              allFeatures = true
            },
            rustfmt = {
              overrideCommand = { "leptosfmt", "--stdin", "--rustfmt" }
            }
          },
        }
      })

      vim.diagnostic.config({
        virtual_text = true
      })
    end,
    init = function()
      -- Disable automatic setup, we are doing it manually
      --vim.g.lsp_zero_extend_cmp = 0
      --vim.g.lsp_zero_extend_lspconfig = 0
      --vim.g.lsp_zero_ui_float_border = 0
    end,
  },
  {
    'williamboman/mason-lspconfig.nvim',
    lazy = false,
    dependencies = {
      { 'williamboman/mason.nvim' }
    },
    config = function()
      local lsp_zero = require('lsp-zero')
      local lsp_config = require('lspconfig')
      require('mason-lspconfig').setup({
        ensure_installed = {
          'lua_ls',
          --'rust_analyzer',
        },
        handlers = {
          function(server_name)
            lsp_config[server_name].setup({})
          end,
          tinymist = function()
            lsp_config.tinymist.setup({
              offset_encoding = "utf-8",
              settings = {
                formatterMode = "typstyle",
                exportPdf = "onSave",
                --semanticTokens = "disable"
              }
            })
          end,
          denols = function()
            lsp_config.denols.setup({ root_dir = lsp_config.util.root_pattern("deno.json", "deno.jsonc"), single_file_support = false })
          end,
          ts_ls = function()
            lsp_config.ts_ls.setup({ root_dir = lsp_config.util.root_pattern("package.json"), single_file_support = false })
          end,
          rust_analyzer = function()
            lsp_config.rust_analyzer.setup({
              cmd = { "rust-analyzer" },
              settings = {
                ["rust-analyzer"] = {
                  checkOnSave = {
                    command = "clippy",
                    extraArgs = { "--target-dir=./target/check" },
                  },
                },
              }
            })
          end,
          html = function()
            lsp_config.html.setup({ filetypes = { 'html', 'templ' } })
          end,
          htmx = function()
            lsp_config.htmx.setup({ filetypes = { 'html', 'templ', 'rust', 'htmldjango' } })
          end,
          tailwindcss = function()
            lsp_config.tailwindcss.setup({ filetypes = { 'html', 'templ', 'javascript', 'typescript', 'typescriptreact', 'react', 'rust' }, init_options = { userLanguages = { templ = "html", rust = "html" } }, })
          end,
          lua_ls = function()
            local lua_opts = lsp_zero.nvim_lua_ls()
            lsp_config.lua_ls.setup(lua_opts)
            --vim.filetype.add({ extension = { templ = "templ" } })
          end,
          nil_ls = function()
            lsp_config.nil_ls.setup({
              settings = {
                ['nil'] = {
                  formatting = {
                    command = { "nixfmt" },
                  },
                },
              },
            })
          end
        }
      })
    end
  },
}
