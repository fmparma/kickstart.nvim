-- Highlight todo, notes, etc in comments
vim.pack.add {
    'https://github.com/folke/todo-comments.nvim',
    -- event = 'VimEnter',
    dependencies = { 'https://github.com/nvim-lua/plenary.nvim' },
    signs = false
}
