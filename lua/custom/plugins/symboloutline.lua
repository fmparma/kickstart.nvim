vim.pack.add {
    'https://github.com/hedyhli/outline.nvim',
    -- cmd = { "Outline", "OutlineOpen" },
}

vim.keymap.set("n", "<leader>o", "<cmd>Outline<CR>", { desc = "Toggle Outline" })
require('outline').setup()
