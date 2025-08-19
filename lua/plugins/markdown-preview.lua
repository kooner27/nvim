-- ~/.config/nvim/lua/plugins/markdown-preview.lua

return {
  "iamcco/markdown-preview.nvim",
  build = "cd app && npm install", -- install dependencies
  ft = "markdown",
  keys = {
    {
      "<leader>mp",
      "<cmd>MarkdownPreviewToggle<cr>",
      desc = "Toggle Markdown Preview in browser",
    },
  },
  init = function()
    -- Customize page title (default is 「${name}」)
    vim.g.mkdp_page_title = "${name}"
    -- Optional: auto start preview when entering markdown buffer
    -- vim.g.mkdp_auto_start = 1
    -- Optional: auto close preview when buffer is closed
    -- vim.g.mkdp_auto_close = 1
  end,
}
