return {
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.8',
        dependencies = { 'plenary' },
        config = function(plugin)
            local telescope = require('telescope')
            local builtin = require('telescope.builtin')

            local function telescope_buffer_dir()
                return vim.fn.expand('%:p:h')
            end


            local fb_actions = telescope.extensions.file_browser.actions

            telescope.setup {
                defaults = {
                    file_ignore_patterns = { "node_modules" }
                },
                extensions = {
                    file_browser = {
                        theme = "dropdown",
                        -- disables netrw and use telescope-file-browser in its place
                        hijack_netrw = false,
                        mappings = {
                            ["n"] = {
                                -- your custom normal mode mappings
                                ["<leader>e"] = fb_actions.rename,
                                ["<leader>c"] = fb_actions.create,
                                ["/"] = function()
                                    vim.cmd('startinsert')
                                end
                            },
                        },
                    },
                },
            }

            telescope.load_extension("file_browser")
            telescope.load_extension("fzf")

            vim.keymap.set('n', 'ff',
                function()
                    builtin.find_files({
                        no_ignore = false,
                        hidden = true,
                    })
                end)
            vim.keymap.set('n', 'fr', builtin.live_grep, {})

            vim.keymap.set('n', 'fb', function()
                builtin.buffers()
            end)
            vim.keymap.set('n', ';t', function()
                builtin.help_tags()
            end)
            vim.keymap.set('n', ';;', function()
                builtin.resume()
            end)
            vim.keymap.set('n', ';e', function()
                builtin.diagnostics()
            end)

            -- Telescope File Browser
            vim.keymap.set("n", "sf", function()
                telescope.extensions.file_browser.file_browser({
                    path = "%:p:h",
                    cwd = telescope_buffer_dir(),
                    respect_gitignore = false,
                    hidden = true,
                    grouped = true,
                    previewer = false,
                    initial_mode = "normal",
                    layout_config = { height = 40 }
                })
            end)
        end
    },
    {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = { "nvim-telescope/telescope.nvim", "plenary", 'nvim-tree/nvim-web-devicons' }
    },
    {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make'
    },
}
