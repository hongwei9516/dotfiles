-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- jk
vim.keymap.set("i", "jk", "<Esc>", { desc = "Exit Insert Mode" })

-- lazy
vim.keymap.set("n", "<leader>z", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- formatting
vim.keymap.set({ "n", "x" }, "<leader>lf", function()
  LazyVim.format({ force = true })
end, { desc = "Format" })

-- Resize window using <ctrl> arrow keys
vim.keymap.set("n", "<C-A-k>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
vim.keymap.set("n", "<C-A-j>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
vim.keymap.set("n", "<C-A-h>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
vim.keymap.set("n", "<C-A-l>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })
