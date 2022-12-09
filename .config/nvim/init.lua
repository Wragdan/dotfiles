require('wragdan.plugins')
require('wragdan.highlights')
require('wragdan.base')
require('wragdan.remaps')


local has = vim.fn.has
local is_mac = has "macunix"
-- local is_win = has "win32"

if is_mac then
  require('wragdan.macos')
end
--if is_win then
--  require('craftzdog.windows')
--end
