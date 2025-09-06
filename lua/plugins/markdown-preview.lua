return {
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    -- build step uses npm
    build = 'cd app && npm install',
    init = function()
      vim.g.mkdp_filetypes = { 'markdown' }
      -- vim.g.mkdp_theme = "dark"
      vim.g.mkdp_preview_options = {
        mkit = {
          ['breaks'] = true, -- strict line breaks OFF
        },
      }
      vim.g.mkdp_markdown_css = vim.fn.expand '~/.config/nvim/github-markdown-dark.css'
    end,
    config = function()
      -- keymap for preview
      vim.keymap.set('n', '<leader>mp', '<cmd>MarkdownPreviewToggle<CR>', { desc = 'Markdown Preview' })
    end,
  },
}
