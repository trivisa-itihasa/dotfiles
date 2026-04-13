-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    if vim.bo.filetype == "snacks_dashboard" then
      vim.schedule(function()
        vim.o.laststatus = 0
        vim.o.showtabline = 0
      end)
    end
  end,
})

-- VeryLazy後にすでにダッシュボードにいる場合（起動時）にも適用
vim.schedule(function()
  if vim.bo.filetype == "snacks_dashboard" then
    vim.o.laststatus = 0
    vim.o.showtabline = 0
  end
end)

vim.api.nvim_create_autocmd("BufLeave", {
  callback = function()
    if vim.bo.filetype == "snacks_dashboard" then
      vim.o.laststatus = 3
      vim.o.showtabline = 1
    end
  end,
})

