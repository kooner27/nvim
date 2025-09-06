-- ~/.config/nvim/lua/plugins/render-markdown.lua
return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('render-markdown').setup {
        clear_in_insert_mode = false, -- keep rendering in insert mode
        render_modes = { 'n', 'i' }, -- render both in normal & insert
        only_render_at_cursor = true, -- only show raw text at cursor line
      }
    end,
  },
}
