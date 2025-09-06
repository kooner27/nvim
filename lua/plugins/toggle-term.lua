return {
  'akinsho/toggleterm.nvim',
  version = '*',
  config = function()
    require('toggleterm').setup {
      open_mapping = [[<C-j>]], -- Set Ctrl+j as the toggle key
      direction = 'float', -- Open as a floating terminal (you can change it to "horizontal" if you prefer)
      float_opts = {
        border = 'curved', -- Choose a border style: "single", "double", "shadow", "curved"
      },
    }
  end,
}
