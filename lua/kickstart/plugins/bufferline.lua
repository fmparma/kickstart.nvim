--  bufferline setting
return {
  {
    'akinsho/bufferline.nvim',
    event = 'VeryLazy',
    dependencies = 'nvim-tree/nvim-web-devicons',
    keys = {
      { '<leader>bp', '<Cmd>BufferLineTogglePin<CR>', desc = 'Toggle Pin' },
      { '<leader>bP', '<Cmd>BufferLineGroupClose ungrouped<CR>', desc = 'Delete Non-Pinned Buffers' },
      { '<leader>br', '<Cmd>BufferLineCloseRight<CR>', desc = 'Delete Buffers to the Right' },
      { '<leader>bl', '<Cmd>BufferLineCloseLeft<CR>', desc = 'Delete Buffers to the Left' },
      { '<S-h>', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev Buffer' },
      { '<S-l>', '<cmd>BufferLineCycleNext<cr>', desc = 'Next Buffer' },
      -- { '<leader>ba', close_all_buffers(), desc = 'Close all Buffers' },
    },
    -- opts = {
    --   options = {
    --     style_preset = style_preset.minimal,
    --     offsets = {
    --       {
    --         filetype = 'NvimTree',
    --         text = 'File Explorer',
    --         highlight = 'Directory',
    --         text_align = 'left',
    --       },
    --     },
    --   },
    -- },

    config = function()
      local bufferline = require 'bufferline'
      bufferline.setup {
        options = {
          -- style_preset = bufferline.style_preset.no_italic,
          -- numbers = function(opts)
          --   return string.format('%s·%s', raise(opts.id), opts.lower(opts.ordinal))
          -- end,
          offsets = {
            {
              filetype = 'NvimTree',
              text = 'File Explorer',
              -- text = function()
              --   return vim.fn.getcwd()
              -- end,
              highlight = 'Directory',
              text_align = 'left',
              separator = true,
            },
          },
        },
      }
      -- Fix bufferline when restoring a session
      vim.api.nvim_create_autocmd({ 'BufAdd', 'BufDelete' }, {
        callback = function()
          vim.schedule(function()
            pcall(nvim_bufferline)
          end)
        end,
      })

      local function close_all_buffers()
        for _, e in ipairs(bufferline.get_elements().elements) do
          vim.schedule(function()
            vim.cmd('bd ' .. e.id)
          end)
        end
      end
    end,
  },
}
