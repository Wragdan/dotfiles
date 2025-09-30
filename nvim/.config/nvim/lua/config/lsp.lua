-- LSP-based completion support
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = false })
    end
  end
})

-- Control LSP support by filetype
vim.lsp.enable({
  'javascript',
  'rust',
  'lua',
  'tailwind',
  'docker',
})

-- LSP logging
vim.lsp.set_log_level("WARN")

-- DIAGNOSTICS

-- How diagnostics are displayed
vim.diagnostic.config({ virtual_text = true })

local bind = vim.keymap.set

bind('n', 'gd', function() vim.lsp.buf.definition() end)
bind('n', '<leader>f', function() require("conform").format() end)
bind('n', ';d', function() vim.diagnostic.open_float() end)
bind('n', '<leader>rn', function() vim.lsp.buf.rename() end)
bind('n', '<leader>ca', function() vim.lsp.buf.code_action() end)
bind('n', '<leader>rr', function() vim.lsp.buf.references() end)
bind('n', ']d', function() vim.diagnostic.goto_next() end)
bind('n', '[d', function() vim.diagnostic.goto_prev() end)
bind('i', '<C-h>', function() vim.lsp.buf.signature_help() end)
bind('i', '<C-space>', function() vim.lsp.completion.get() end)

--vim.api.nvim_create_autocmd("BufWritePre", {
--  pattern = "*",
--  callback = function(args)
--    conform.format({ bufnr = args.buf })
--  end,
--})
