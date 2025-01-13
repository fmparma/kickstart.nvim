return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    bigfile = { enabled = false },
    dashboard = {
      enabled = true,
      sections = {
        { section = 'header' },
        { section = 'keys', gap = 1, padding = 1 },
        {
          pane = 2,
          section = 'terminal',
          cmd = 'ascii-image-converter C:/Users/admin/AppData/Local/nvim-kickstart/image/OP2.jpg -C -c -m **',
          padding = 1,
          random = 10,
          -- ttl = 1,
          indent = 4,
          height = 35,
          width = 80,
        },
        { section = 'startup' },
      },
    },
    indent = {
      enabled = true,
      scope = {
        underline = true,
      },
    },
    input = { enabled = false },
    notifier = { enabled = false },
    quickfile = { enabled = false },
    scroll = { enabled = false },
    statuscolumn = { enabled = false },
    words = { enabled = false },
  },
}
