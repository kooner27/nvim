return {
  {
    'catppuccin/nvim',
    lazy = false,
    name = 'catppuccin',
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'catppuccin'
    end,
  },

  {
    'ellisonleao/gruvbox.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('gruvbox').setup {
        contrast = 'soft', -- can be "hard", "soft", or empty string
        -- overrides = {
        --   -- Markdown heading overrides
        --   ["@markup.heading.1.markdown"] = { fg = "#fb4934", bold = true }, -- red
        --   ["@markup.heading.2.markdown"] = { fg = "#b8bb26", bold = true }, -- green
        --   ["@markup.heading.3.markdown"] = { fg = "#fabd2f", bold = true }, -- yellow
        -- },
      }
      -- vim.cmd.colorscheme("gruvbox")
    end,
  },

  {
    'sainnhe/gruvbox-material',
    lazy = false,
    name = 'gruvbox-material',
    priority = 1000,
    config = function()
      -- overrides = {
      --   ["@markup.heading.1.markdown"] = { fg = "#fb4934", bold = true }, -- red
      --   ["@markup.heading.2.markdown"] = { fg = "#b8bb26", bold = true }, -- green
      --   ["@markup.heading.3.markdown"] = { fg = "#fabd2f", bold = true }, -- yellow
      -- }
      vim.g.gruvbox_material_background = 'medium' -- 'hard', 'medium', 'soft'
      vim.g.gruvbox_material_foreground = 'material' -- 'material', 'mix', 'original'
      -- vim.g.gruvbox_material_better_performance = 1
      -- vim.cmd.colorscheme("gruvbox-material")
    end,
  },
}

-- return {
--   "ellisonleao/gruvbox.nvim",
--   lazy = false,
--   priority = 1000,
--   config = function()
--     require("gruvbox").setup({
--       contrast = "soft", -- can be "hard", "soft", or empty string
--       overrides = {
--         -- Markdown heading overrides
-- ["@markup.heading.1.markdown"] = { fg = "#fb4934", bold = true }, -- red
-- ["@markup.heading.2.markdown"] = { fg = "#b8bb26", bold = true }, -- green
-- ["@markup.heading.3.markdown"] = { fg = "#fabd2f", bold = true }, -- yellow
--       },
--     })
--     vim.cmd.colorscheme("gruvbox")
--   end,
-- }

-- return {
--   "sainnhe/gruvbox-material",
--   lazy = false,
--   name = "gruvbox-material",
--   priority = 1000,
--   config = function()
--     -- overrides = {
--     --   ["@markup.heading.1.markdown"] = { fg = "#fb4934", bold = true }, -- red
--     --   ["@markup.heading.2.markdown"] = { fg = "#b8bb26", bold = true }, -- green
--     --   ["@markup.heading.3.markdown"] = { fg = "#fabd2f", bold = true }, -- yellow
--     -- }
--     vim.g.gruvbox_material_background = "medium" -- 'hard', 'medium', 'soft'
--     vim.g.gruvbox_material_foreground = "original" -- 'material', 'mix', 'original'
--     -- vim.g.gruvbox_material_better_performance = 1
--     vim.cmd.colorscheme("gruvbox-material")
--   end,
-- }

-- return {
--   "rebelot/kanagawa.nvim",
--   lazy = false,
--   priority = 1000,
--   config = function()
--     vim.cmd.colorscheme("kanagawa")
--   end,
-- }
