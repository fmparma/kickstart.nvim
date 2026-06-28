--  Auto Session: save/restore Neovim sessions
--  Lazy-loaded: only loads when SessionSearch, SessionSave, or SessionToggleAutoSave is called.
vim.pack.add {
    'https://github.com/rmagatti/auto-session',
}

-- Keymaps (available before plugin loads; will use Telescope or vim.ui.select picker)
vim.keymap.set('n', '<leader>wr', '<cmd>AutoSession search<CR>', { desc = 'Session search' })
vim.keymap.set('n', '<leader>wS', '<cmd>AutoSession save<CR>', { desc = 'Save session' })
vim.keymap.set('n', '<leader>wa', '<cmd>AutoSession toggle<CR>', { desc = 'Toggle autosave' })

---@module "auto-session"
require('auto-session').setup {
    -- ⚠️ This will only work if Telescope.nvim is installed
    -- The following are already the default values, no need to provide them if these are already the settings you want.
    -- Enable/Disable auto saving session on exit
    auto_save = false,
    -- On startup, loads the last saved session if session for cwd does not exist
    -- auto_restore_last_session = false,
    session_lens = {
        -- If load_on_setup is false, make sure you use `:SessionSearch` to open the picker as it will initialize everything first
        load_on_setup = true,
        previewer = false,
        mappings = {
            -- Mode can be a string or a table, e.g. {"i", "n"} for both insert and normal mode
            delete_session = { 'i', '<C-D>' },
            alternate_session = { 'i', '<C-S>' },
        },
        -- Can also set some Telescope picker options
        theme_conf = {
            border = true,
            -- layout_config = {
            --   width = 0.8, -- Can set width and height as percent of window
            --   height = 0.5,
            -- },
        },
    },
}
