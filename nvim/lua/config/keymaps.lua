-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- change <Leader>
vim.g.mapleader = " "

-- push jk to switch to normal mode
vim.keymap.set("i", "jk", "<Esc>", { noremap = true })
