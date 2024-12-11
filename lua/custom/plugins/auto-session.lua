return {
  'rmagatti/auto-session',
  lazy = false,
  dependencies = {
    'nvim-telescope/telescope.nvim',
  },
  keys = {
    -- Will use Telescope if installed or a vim.ui.select picker otherwise
    { '<leader>sR', '<cmd>SessionSearch<CR>', desc = 'Session search' },
    { '<leader>sS', '<cmd>SessionSave<CR>', desc = 'Save session' },
    { '<leader>sa', '<cmd>SessionToggleAutoSave<CR>', desc = 'Toggle autosave' },
  },

  ---enables autocomplete for opts
  ---@module "auto-session"
  opts = {
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
        delete_session = { "i", "<C-D>" },
        alternate_session = { "i", "<C-S>" },
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
}
