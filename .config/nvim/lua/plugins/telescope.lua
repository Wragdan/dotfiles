return {
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.5',
        dependencies = { 'plenary' },
        config = function(plugin)
            local telescope = require('telescope')
            local builtin = require('telescope.builtin')

            local function telescope_buffer_dir()
                return vim.fn.expand('%:p:h')
            end


            local fb_actions = telescope.extensions.file_browser.actions
            local z_utils = require("telescope._extensions.zoxide.utils")


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
                                ["<leader>."] = fb_actions.goto_parent_dir,
                                ["/"] = function()
                                    vim.cmd('startinsert')
                                end
                            },
                        },
                    },
                    zoxide = {
                        prompt_title = "[ Recent Directories ]",
                        mappings = {
                            default = {
                                action = function(selection)
                                    vim.cmd("edit " .. selection.path)
                                end,
                            },
                            -- Opens the selected entry in a new split
                            ["<leader>s"] = { action = z_utils.create_basic_command("vsplit") },
                        },
                    },
                },
            }

            telescope.load_extension("file_browser")
            telescope.load_extension("zoxide")
            telescope.load_extension("fzf")

            vim.keymap.set('n', 'ff',
                function()
                    builtin.find_files({
                        no_ignore = false,
                        hidden = true,
                    })
                end)
            vim.keymap.set('n', 'fr', builtin.live_grep, {})

            vim.keymap.set('n', '\\\\', function()
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

            vim.keymap.set('n', ';gb', function()
                builtin.git_branches()
            end)

            -- Telescope zoxide
            vim.keymap.set("n", "cd", telescope.extensions.zoxide.list)


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
    {
        'jvgrootveld/telescope-zoxide',
        dependencies = { 'nvim-telescope/telescope.nvim', 'plenary', 'nvim-lua/popup.nvim' }
    },
}
