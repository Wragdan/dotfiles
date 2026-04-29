require('vim._core.ui2').enable({
  enable = true, -- Whether to enable or disable the UI.
  msg = { -- Options related to the message module.
    ---@type 'cmd'|'msg' Default message target, either in the
    ---cmdline or in a separate ephemeral message window.
    ---@type string|table<string, 'cmd'|'msg'|'pager'> Default message target
    ---or table mapping |ui-messages| kinds and triggers to a target.
    targets = 'cmd',
    cmd = { -- Options related to messages in the cmdline window.
      height = 0.5 -- Maximum height while expanded for messages beyond 'cmdheight'.
    },
    dialog = { -- Options related to dialog window.
      height = 0.5, -- Maximum height.
    },
    msg = { -- Options related to msg window.
      height = 0.5, -- Maximum height.
      timeout = 4000, -- Time a message is visible in the message window.
    },
    pager = { -- Options related to message window.
      height = 1, -- Maximum height.
    },
  },
})
require("config.remaps")
require("config.settings")
require("config.lsp")

require("config.pack")

require('plugins.catppuccin')
require('plugins.formatter')
require('plugins.oil')
require('plugins.gitsigns')
require('plugins.fugitive')
require('plugins.fzf')
require('plugins.mason')
require('plugins.treesitter')
require('plugins.autocompletion')
require('plugins.autocompletion')


vim.api.nvim_create_autocmd("LspProgress", {
  callback = function(ev)
    local value = ev.data.params.value or {}
    local msg = value.message or "done"

    -- rust-analyzer in particular sends extremely long messages
    if #msg > 40 then
      msg = msg:sub(1, 37) .. "..."
    end

    vim.api.nvim_echo({{msg}}, false, {
      id     = "lsp",
      kind   = "progress",
      source = "lsp",
      title  = value.title,
      status = value.kind ~= "end" and "running" or "success",
      percent = value.percentage,
    })
  end,
})
