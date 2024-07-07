return {
    {
        'lewis6991/gitsigns.nvim',
        config = function()
            local signs = require('gitsigns')

            signs.setup()
        end
    }
}
