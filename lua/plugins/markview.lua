return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    dependencies = {
      {
        "OXY2DEV/markview.nvim",
        lazy = false,
        priority = 49,
        dependencies = {
          "nvim-tree/nvim-web-devicons",
          "saghen/blink.cmp",
        },
        config = function()
          local markview = require("markview")

          markview.setup({
            preview = {
              icon_provider = "devicons",
              enable = true,
              modes = { "n", "i" }, -- preview active in both modes
              hybrid_modes = { "n", "i" }, -- allows raw lines
              filetypes = { "md", "markdown", "quarto" },
              splitview_winopts = { split = "left" },
            },
          })

          vim.api.nvim_create_autocmd("User", {
            pattern = "MarkviewAttach",
            callback = function()
              vim.cmd("Markview HybridEnable")
              vim.cmd("Markview LinewiseEnable") -- ✅ must call this manually
            end,
          })

          require("markview.extras.checkboxes").setup()
        end,
      },
    },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "markdown",
          "markdown_inline",
          "html",
        },
        highlight = { enable = true },
      })
    end,
  },
}
