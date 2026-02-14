return {

  {
    "xiyaowong/transparent.nvim",
    config = function()
      require("transparent").setup({})
      require("transparent").clear_prefix("NeoTree")
    end,
  },

  {
    "loctvl842/monokai-pro.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("monokai-pro").setup({
        filter = "pro",
        transparent_background = true,
      })
    end,
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "monokai-pro",
    },
  },
}
