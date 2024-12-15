-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Display the number and relative number in the preview
-- vim.api.nivm_create_autocmd('User', {
--   desc = 'Display number in preview of telescope',
--   pattern = 'TelescopePreviewerLoaded',
--   callback = function(buf)
--     local winid = buf.data.winid
--     vim.wo[winid].number = true
--   end,
-- })

-- vim: ts=2 sts=2 sw=2 et