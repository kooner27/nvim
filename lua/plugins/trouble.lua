return {
  'folke/trouble.nvim',
  opts = {},
  cmd = 'Trouble',
  keys = {
    -- Keybindings for trouble commands
    { '<leader>xx', '<cmd>Trouble diagnostics toggle focus=true<cr>', desc = 'Diagnostics (Trouble)' },
    {
      '<leader>xX',
      '<cmd>Trouble diagnostics toggle filter.buf=0 focust=true<cr>',
      desc = 'Buffer Diagnostics (Trouble)',
    },
    { '<leader>cs', '<cmd>Trouble symbols toggle focus=false<cr>', desc = 'Symbols (Trouble)' },
    {
      '<leader>cl',
      '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
      desc = 'LSP Definitions / references / ... (Trouble)',
    },
    { '<leader>xL', '<cmd>Trouble loclist toggle<cr>', desc = 'Location List (Trouble)' },
    { '<leader>xQ', '<cmd>Trouble qflist toggle<cr>', desc = 'Quickfix List (Trouble)' },
  },
  config = function()
    -- Load Trouble normally without statusline config for testing
    require('trouble').setup {}

    -- Telescope integration
    local telescope = require 'telescope'
    local actions = require 'telescope.actions'
    local open_with_trouble = require('trouble.sources.telescope').open
    telescope.setup {
      defaults = {
        mappings = {
          i = { ['<c-t>'] = open_with_trouble },
          n = { ['<c-t>'] = open_with_trouble },
        },
      },
    }
  end,
}
