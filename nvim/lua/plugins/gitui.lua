return {
  {
    "akinsho/toggleterm.nvim",
    config = function()
      require("toggleterm").setup({
        direction = "float",
        float_opts = {
          border = "curved",
        },
      })

      local Terminal = require("toggleterm.terminal").Terminal
      local gitui_cmd = vim.fn.exepath("gitui")
      if gitui_cmd == "" then
        vim.notify("gitui not found in PATH", vim.log.levels.ERROR)
        return
      end

      local gitui = Terminal:new({
        cmd = gitui_cmd,
        hidden = true,
        direction = "float",
        on_open = function(term)
          vim.cmd("startinsert!")
          vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
        end,
      })

      local function toggle()
        gitui:toggle()
      end

      -- Set after VeryLazy to override LazyVim's default <leader>gg (lazygit)
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        once = true,
        callback = function()
          pcall(vim.keymap.del, "n", "<leader>gg")
          vim.keymap.set("n", "<leader>gg", toggle, { desc = "GitUI (Float)" })
        end,
      })
    end,
  },
}
