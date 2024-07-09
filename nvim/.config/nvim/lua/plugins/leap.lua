return {
    {
        'ggandor/leap.nvim',
        config = function()
            --require('leap').create_default_mappings()
            vim.keymap.set({ 'n', 'x', 'o' }, 'x', '<Plug>(leap-forward)')
            vim.keymap.set({ 'n', 'x', 'o' }, 'X', '<Plug>(leap-backward)')
            vim.keymap.set({ 'n', 'x', 'o' }, 'gs', '<Plug>(leap-from-window)')
        end
    }
}
