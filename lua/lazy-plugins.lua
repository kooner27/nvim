-- [[ Configure and install plugins ]]
require('lazy').setup {
  -- Import every *.lua file from these folders as plugin specs:
  { import = 'plugins' }, -- your new folder (optional, use it freely)

  -- You can still list one-off plugins inline if you want:
  --  'NMAC427/guess-indent.nvim',
}

--
-- -- [[ Configure and install plugins ]]
-- require('lazy').setup({
--   -- Import every *.lua file from these folders as plugin specs:
--   { import = 'plugins' },           -- your new folder (optional, use it freely)
--
--   -- You can still list one-off plugins inline if you want:
-- --  'NMAC427/guess-indent.nvim',
-- }, {
--   ui = {
--     icons = vim.g.have_nerd_font and {} or {
--       cmd = '⌘', config = '🛠', event = '📅', ft = '📂', init = '⚙',
--       keys = '🗝', plugin = '🔌', runtime = '💻', require = '🌙',
--       source = '📄', start = '🚀', task = '📌', lazy = '💤 ',
--     },
--   },
-- })
--
