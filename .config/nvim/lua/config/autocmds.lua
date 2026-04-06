-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Hide statusline on dashboard
local function hide_statusline()
  vim.o.laststatus = 0
  vim.o.showtabline = 0
end
local function show_statusline()
  vim.o.laststatus = 3
  vim.o.showtabline = 1
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "snacks_dashboard",
  callback = hide_statusline,
})
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function(ev)
    if vim.bo[ev.buf].filetype == "snacks_dashboard" then
      hide_statusline()
    end
  end,
})
vim.api.nvim_create_autocmd("BufLeave", {
  callback = function(ev)
    if vim.bo[ev.buf].filetype == "snacks_dashboard" then
      show_statusline()
    end
  end,
})

-- Apply immediately if already on dashboard when VeryLazy fires
if vim.bo.filetype == "snacks_dashboard" then
  hide_statusline()
end
