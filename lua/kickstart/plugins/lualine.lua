--  Status line
return {
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    init = function()
      vim.g.lualine_laststatus = vim.o.laststatus
      if vim.fn.argc(-1) > 0 then
        -- set an empty statusline till lualine loads
        vim.o.statusline = ' '
      else
        -- hide the statusline on the starter page
        vim.o.laststatus = 0
      end
    end,
    opts = function()
      -- PERF: we don't need this lualine require madness 🤷
      local lualine_require = require 'lualine_require'
      lualine_require.require = require

      vim.o.laststatus = vim.g.lualine_laststatus

      local opts = {
        options = {
          theme = 'auto',
          -- theme = 'gruvbox',
          globalstatus = vim.o.laststatus == 3,
          disabled_filetypes = { statusline = { 'dashboard', 'alpha', 'ministarter', 'snacks_dashboard' } },
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch' },

          lualine_c = {
            {
              'diagnostics',
              symbols = {
                error = 'E',
                warn = 'W',
                info = 'I',
                hint = 'H',
              },
              diagnostics_color = {
                -- Same values as the general color option can be used here.
                error = 'DiagnosticError', -- Changes diagnostics' error color.
                warn = 'DiagnosticWarn', -- Changes diagnostics' warn color.
                info = 'DiagnosticInfo', -- Changes diagnostics' info color.
                hint = 'DiagnosticHint', -- Changes diagnostics' hint color.
              },
              colored = true, -- Displays diagnostics status in color if set to true.
            },
            {
              'filetype',
              colored = true,
              -- Not only display icon
              -- icon_only = true,
              -- icon = { align = 'right' }, -- Display filetype icon on the right hand side
              -- icon =    {'X', align='right'}
              -- Icon string ^ in table is ignored in filetype component
              separator = ' ',
              padding = { left = 1, right = 0 },
            },
          },
          lualine_x = {
          -- stylua: ignore
            {
              'diff',
              symbols = {
                added = '+',
                modified = '~',
                removed = '-',
              },
             diff_color = {
                -- Same color values as the general color option can be used here.
                added    = 'LuaLineDiffAdd',    -- Changes the diff's added color
                modified = 'LuaLineDiffChange', -- Changes the diff's modified color
                removed  = 'LuaLineDiffDelete', -- Changes the diff's removed color you
              },
              source = function()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                  return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed,
                  }
                end
              end,
            },
            {
              function()
                local bufnr = vim.api.nvim_get_current_buf()
                for _, client in ipairs(vim.lsp.get_clients()) do
                  if client.attached_buffers[bufnr] then
                    return ' LSP ~ ' .. client.name
                  end
                end
              end,
              padding = { left = 0, right = 1 },
            },
          },
          lualine_y = {
            { 'progress', separator = ' ', padding = { left = 1, right = 0 } },
            { 'location', padding = { left = 0, right = 1 } },
          },
          lualine_z = {
            -- function()
            --   return ' ' .. os.date '%R'
            -- end,
            {
              'fileformat',
              symbols = {
                unix = '', -- e712
                dos = '', -- e70f
                mac = '', -- e711
              },
              separator = ' ',
              padding = { left = 1, right = 0 },
            },
            {
              'encoding',
              -- Show '[BOM]' when the file has a byte-order mark
              show_bomb = false,
              padding = { left = 0, right = 1 },
            },
          },
        },
      }

      return opts
    end,
  },
}
