return {
  'olimorris/persisted.nvim',
  event = 'VeryLazy',
  opts = {
    autostart = false, -- manual only
    autoload = false, -- don't autoload on startup
    use_git_branch = true,
    follow_cwd = true,
  },
  config = function(_, opts)
    local persisted = require 'persisted'
    persisted.setup(opts)

    local ok, telescope = pcall(require, 'telescope')
    if ok then
      telescope.load_extension 'persisted'
    end

    -- Keymaps (uppercase <leader>S for sessions)
    local map = vim.keymap.set
    local keyopts = { noremap = true, silent = true }

    map('n', '<leader>Ss', '<cmd>SessionSave<CR>', vim.tbl_extend('force', keyopts, { desc = 'Save session' }))
    map('n', '<leader>Sl', '<cmd>SessionLoad<CR>', vim.tbl_extend('force', keyopts, { desc = 'Load session' }))
    map('n', '<leader>Sd', '<cmd>SessionDelete<CR>', vim.tbl_extend('force', keyopts, { desc = 'Delete session' }))
    map('n', '<leader>Se', '<cmd>Telescope persisted<CR>', vim.tbl_extend('force', keyopts, { desc = 'Session explorer' }))
  end,
}
