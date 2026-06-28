-- You can easily change to a different colorscheme.
-- Change the name of the colorscheme plugin below, and then
-- change the command in the config to whatever the name of that colorscheme is.
-- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
-- vim.pack.add {
--   'https://github.com/folke/tokyonight.nvim',
--   enabled = false,
--   priority = 1000,   -- Make sure to load this before all the other start plugins.
--   init = function()
--     -- Load the colorscheme here.
--     -- Like many other themes, this one has different styles, and you could load
--     -- any other, such as 'tokyonight-night', 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
--     vim.cmd.colorscheme 'tokyonight-moon'

--     -- You can configure highlights by doing something like:
--     vim.cmd.hi 'Comment gui=none'
--   end,
-- }


-- vim.pack.add { 'https://github.com/NMAC427/guess-indent.nvim' }
-- require('guess-indent').setup {}

-- everforest colorscheme
-- Lua ported everforest
vim.pack.add {
    "https://github.com/neanias/everforest-nvim",
    -- priority = 1000, -- make sure to load this before all the other start plugins
}

require("everforest").setup({
    -- Your config here
    background = 'hard',
    on_highlights = function(hl, palette)
        hl.CursorLineNr = { fg = palette.fg, bg = palette.none, sp = palette.red }
        hl.IblScope = { fg = palette.green, bg = palette.none, sp = palette.green }
    end,
})

-- Load the colorscheme here.
-- Like many other themes, this one has different styles, and you could load
-- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
vim.cmd.colorscheme('everforest')
