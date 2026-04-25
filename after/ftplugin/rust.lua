local bufnr = vim.api.nvim_get_current_buf()

-- Code actions
vim.keymap.set("n", "<leader>a", function()
  vim.cmd.RustLsp('codeAction')
end, { buffer = bufnr, silent = true })

-- Hover + actions
vim.keymap.set("n", "K", function()
  vim.cmd.RustLsp({ 'hover', 'actions' })
end, { buffer = bufnr, silent = true })

-- Go to definition
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr })

-- Rename
vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { buffer = bufnr })

-- Diagnostics
-- navigate diagnostics
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Previous diagnostic' })

-- show all diagnostics in a list
vim.keymap.set('n', '<leader>d', vim.diagnostic.setloclist, { desc = 'Diagnostics list' })
