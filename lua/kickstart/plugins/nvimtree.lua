--  Set nvim-tree
--  Lazy-loaded: only loads when NvimTreeToggle or NvimTreeFocus is called.
--  See `:help vim.pack` for spec options.
vim.pack.add {
    'https://github.com/nvim-tree/nvim-tree.lua',
    -- cmd = { 'NvimTreeToggle', 'NvimTreeFocus' },
    'https://github.com/nvim-tree/nvim-web-devicons',
}

require('nvim-tree').setup({
    -- filters = { dotfiles = true },
    -- disable_netrw = true,
    -- hijack_netrw = true,
    -- hijack_cursor = true,
    -- sync_root_with_cwd = true,
    -- update_focused_file = {
    --     enable = true,
    --     -- update_root = false,
    -- },
    -- git = {
    --     -- if enable, openning file or file-pro will freeze, so disable git.
    --     enable = false,
    --     -- if enable git, it recommand to set a timeout
    --     -- each git process is discarded after a configured timeout.
    --     -- timeout = 400 -- ms
    -- },
    -- view = {
    --     width = 30,
    --     preserve_window_proportions = true,
    -- },
    -- actions = {
    --     open_file = {
    --         resize_window = false,
    --     },
    -- },
    renderer = {
        -- root_folder_label = false,
        highlight_git = 'all',
        indent_markers = { enable = true },
        icons = {
            glyphs = {
                default = '󰈚',
                folder = {
                    default = '',
                    empty = '',
                    empty_open = '',
                    open = '',
                    symlink = '',
                },
                git = { unmerged = '' },
            },
        },
    },
})
