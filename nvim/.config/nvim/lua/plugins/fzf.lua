local fzf = require("fzf-lua")

fzf.setup()
vim.keymap.set("n", "ff", function()
	fzf.files()
end)
vim.keymap.set("n", "fr", "<cmd>FzfLua grep_visual<cr>")
vim.keymap.set("n", ";e", "<cmd>FzfLua diagnostics_workspace<cr>")
