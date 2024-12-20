return {
  -- 'xiyaowong/virtcolumn.nvim',
  'lukas-reineke/virt-column.nvim',
  -- enabled = false,
  -- event = 'VeryLazy',
  -- opts = {},

  -- init setting
  -- int = function()
  --   vim.cmd.hi 'ColorColumn ctermbg=LightYellow guibg=LightYellow'
  -- end,

  config = function()
    -- vim.cmd.hi 'ColorColumn ctermbg=LightYellow guibg=LightYellow'
    require('virt-column').setup()
  end,
}
