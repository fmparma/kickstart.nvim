return {
  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    'folke/tokyonight.nvim',
    enabled = false,
    priority = 1000, -- Make sure to load this before all the other start plugins.
    init = function()
      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-night', 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      vim.cmd.colorscheme 'tokyonight-moon'

      -- You can configure highlights by doing something like:
      vim.cmd.hi 'Comment gui=none'
    end,
  },
  -- everforest colorscheme
  {
    -- everforest writed by vim
    'sainnhe/everforest',
    enabled = false,
    lazy = false,
    priority = 1000,
    init = function()
      -- Optionally configure and load the colorscheme
      -- directory inside the plugin declaration.
      vim.g.everforest_enable_italic = true
      -- The background contrast usde in this color scheme.
      -- Available values: 'hard', 'medium', 'soft'
      -- Default value: 'medium'
      vim.g.everforest_background = 'hard'
      -- You can use thi option to adjust the way these virtual texts are highlighted
      -- Available values: 'grey', 'colored', 'highligted'
      -- default value: 'grey'
      vim.g.everforest_diagnostic_virtual_text = 'colored'
      -- Highlight the word under current cursor
      -- Available values: 'grey background', 'high contrast background', 'bold', 'underline', 'italic'
      -- Default value: 'grey background'
      vim.g.everforest_current_word = 'high contrast background'
      -- vim.api.nvim_create_autocmd('ColorScheme', {
      --   group = vim.api.nvim_create_augroup('custom_highlights_everforest', {}),
      --   pattern = 'everforest',
      --   callback = function()
      --     local config = vim.fn['everforest#get_configuration']()
      --     local palette = vim.fn['everforest#get_palette'](config.background, config.colores_override)
      --     local set_hl = vim.fn['everforest#highlight']
      --
      --     set_hl('CursorLineNr', palette.none, palette.bg_visual_yellow)
      --   end
      -- })
      vim.cmd.colorscheme('everforest')
    end,
  },
  {
    -- Lua ported everforest
    "neanias/everforest-nvim",
    lazy = false,
    priority = 1000, -- make sure to load this before all the other start plugins
    -- Optional; default configuration will be used if setup isn't called.
    init = function()
      require("everforest").setup({
        -- Your config here
        background = 'hard',
        on_highlights = function(hl, palette)
          hl.CursorLineNr = { fg = palette.fg, bg = palette.none, sp = palette.red }
        end,
      })
      vim.cmd.colorscheme('everforest')
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
