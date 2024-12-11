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
    },

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
              -- text = 'File Explorer',
              text = function()
                local cwd = vim.fn.getcwd()
                return vim.fn.pathshorten(cwd)
              end,
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

      -- Common kill function for bdelete and bwipeout
      -- credits: based on bbye and nvim-bufdel
      ---@param kill_command? string defaults to "bd"
      ---@param bufnr? number defaults to the current buffer
      ---@param force? boolean defaults to false
      local function buf_kill(kill_command, bufnr, force)
        kill_command = kill_command or 'bd'

        local bo = vim.bo
        local api = vim.api
        local fmt = string.format
        local fnamemodify = vim.fn.fnamemodify

        if bufnr == 0 or bufnr == nil then
          bufnr = api.nvim_get_current_buf()
        end

        local bufname = api.nvim_buf_get_name(bufnr)

        if not force then
          local warning
          if bo[bufnr].modified then
            warning = fmt([[No write since last change for (%s)]], fnamemodify(bufname, ':t'))
          elseif api.nvim_buf_get_option(bufnr, 'buftype') == 'terminal' then
            warning = fmt([[Terminal %s will be killed]], bufname)
          end
          if warning then
            vim.ui.input({
              prompt = string.format([[%s. Close it anyway? [y]es or [n]o (default: no): ]], warning),
            }, function(choice)
              if choice:match 'ye?s?' then
                force = true
              end
            end)
            if not force then
              return
            end
          end
        end

        -- Get list of windows IDs with the buffer to close
        local windows = vim.tbl_filter(function(win)
          return api.nvim_win_get_buf(win) == bufnr
        end, api.nvim_list_wins())

        if #windows == 0 then
          return
        end

        if force then
          kill_command = kill_command .. '!'
        end

        -- Get list of active buffers
        local buffers = vim.tbl_filter(function(buf)
          return api.nvim_buf_is_valid(buf) and bo[buf].buflisted
        end, api.nvim_list_bufs())

        -- If there is only one buffer (which has to be the current one), vim will
        -- create a new buffer on :bd.
        -- For more than one buffer, pick the previous buffer (wrapping around if necessary)
        if #buffers > 1 then
          for i, v in ipairs(buffers) do
            if v == bufnr then
              local prev_buf_idx = i == 1 and (#buffers - 1) or (i - 1)
              local prev_buffer = buffers[prev_buf_idx]
              for _, win in ipairs(windows) do
                api.nvim_win_set_buf(win, prev_buffer)
              end
            end
          end
        end

        -- Check if buffer still exists, to ensure the target buffer wasn't killed
        -- due to options like bufhidden=wipe.
        if api.nvim_buf_is_valid(bufnr) and bo[bufnr].buflisted then
          vim.cmd(string.format('%s %d', kill_command, bufnr))
        end
      end

      vim.keymap.set('n', '<leader>x', function()
        buf_kill('bd', 0, false)
      end, { desc = 'Close buffer' })
    end,
  },
}
