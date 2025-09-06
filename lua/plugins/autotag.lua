return {
  {
    'windwp/nvim-ts-autotag',
    event = { 'BufReadPre', 'BufNewFile' }, -- Lazy load on these events
    dependencies = {
      'nvim-treesitter/nvim-treesitter', -- Ensure treesitter is installed
    },
    config = function()
      require('nvim-ts-autotag').setup {
        opts = {
          enable_close = true, -- Auto close tags
          enable_rename = true, -- Auto rename matching tags
          enable_close_on_slash = false, -- Don't auto-close on trailing </
        },
        -- Override specific filetypes if needed
        per_filetype = {
          html = {
            enable_close = true,
          },
        },
      }
    end,
  },
}
