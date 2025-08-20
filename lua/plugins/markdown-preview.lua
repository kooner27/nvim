return {
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    -- build step uses npm
    build = "cd app && npm install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
      vim.g.mkdp_theme = "dark" -- optional
      vim.g.mkdp_preview_options = {
        mkit = {
          ["breaks"] = false, -- strict line breaks OFF
        },
      }
    end,
    config = function()
      -- keymap for preview
      vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>", { desc = "Markdown Preview" })
    end,
  },
}
