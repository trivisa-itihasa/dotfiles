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
      local from_dashboard = false
      local gitui = Terminal:new({
        cmd = "gitui",
        hidden = true,
        direction = "float",
        on_open = function(term)
          vim.cmd("startinsert!")
          vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
          vim.schedule(function()
            vim.api.nvim_set_hl(0, "GituiNormalFloat", { bg = "#2d2a2e" })
            vim.api.nvim_set_hl(0, "GituiFloatBorder", { fg = "#fcfcfa", bg = "#2d2a2e" })
            if vim.api.nvim_win_is_valid(term.window) then
              vim.api.nvim_set_option_value("winhl", "NormalFloat:GituiNormalFloat,FloatBorder:GituiFloatBorder", { win = term.window })
            end
          end)
        end,
        on_close = function()
          if from_dashboard then
            vim.schedule(function()
              vim.o.laststatus = 0
              vim.o.showtabline = 0
              vim.cmd("redraw!")
            end)
          end
        end,
      })

      local function toggle()
        from_dashboard = vim.bo.filetype == "snacks_dashboard"
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
