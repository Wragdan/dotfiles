vim.cmd("autocmd!")

-- hightlights
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.winblend = 0
vim.opt.wildoptions = 'pum'
vim.opt.pumblend = 5
vim.opt.background = 'dark'

--vim.scriptencoding = 'utf-8'
--vim.opt.encoding = 'utf-8'
--vim.opt.fileencoding = 'utf-8'

vim.wo.number = true
vim.wo.relativenumber = true

vim.opt.title = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.backup = false
vim.opt.showcmd = true
vim.opt.cmdheight = 1
vim.opt.laststatus = 2
vim.opt.expandtab = true
vim.opt.scrolloff = 16
vim.opt.shell = 'zsh'
vim.opt.backupskip = { '/tmp/*', '/private/tmp/*' }
vim.opt.inccommand = 'split'
vim.opt.ignorecase = true
vim.opt.smarttab = true
vim.opt.breakindent = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.wrap = false
vim.opt.backspace = { 'start', 'eol', 'indent' }
vim.opt.path:append { '**' }
vim.opt.wildignore:append { '*/node_modules/*' }

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.clipboard:append { 'unnamedplus' }

vim.opt.updatetime = 50
--vim.opt.colorcolumn = "120"

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "Xresources", "Xdefaults", "xresources", "xdefaults" },
  command = [[ set filetype=xdefaults ]],
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*/templates/*.html" },
  command = [[ set filetype=htmldjango ]],
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  pattern = { "Xresources", "Xdefaults", "xresources", "xdefaults" },
  command = [[ !xrdb % ]],
})

vim.g.markdown_fenced_languages = {
  "ts=typescript"
}
