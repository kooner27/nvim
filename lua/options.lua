-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`
vim.g.have_nerd_font = true

-- Global indentation and wrap
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.wrap = false
vim.g.mapleader = ' '

-- line
vim.opt.number = true
vim.opt.fillchars:append { eob = ' ' }
vim.opt.cursorline = true

-- scroll off
vim.opt.scrolloff = 10
vim.keymap.set('n', '<leader>ts', function()
  if vim.o.scrolloff == 0 then
    vim.o.scrolloff = 10
    print 'scrolloff = 10'
  else
    vim.o.scrolloff = 0
    print 'scrolloff = 0'
  end
end, { desc = 'Toggle scrolloff between 10 and 0' })

local view_group = vim.api.nvim_create_augroup('remember_view', { clear = true })

vim.api.nvim_create_autocmd('BufLeave', {
  group = view_group,
  callback = function()
    vim.b.saved_view = vim.fn.winsaveview()
  end,
})

vim.api.nvim_create_autocmd('BufEnter', {
  group = view_group,
  callback = function()
    if vim.b.saved_view then
      vim.fn.winrestview(vim.b.saved_view)
    end
  end,
})

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

-- Remove auto comment formatting stuff
-- Remove 'c', 'r', and 'o' from formatoptions globally
vim.api.nvim_create_autocmd('FileType', {
  pattern = '*',
  callback = function()
    vim.opt_local.formatoptions:remove 'c'
    vim.opt_local.formatoptions:remove 'r'
    vim.opt_local.formatoptions:remove 'o'
  end,
})

-- list chars and white space
vim.opt.listchars = {
  space = '·',
  tab = '→ ',
  trail = '·',
  extends = '>',
  precedes = '<',
  nbsp = '␣',
}
-- white space visibilty
local whitespace_visible = false
local function toggle_whitespace()
  whitespace_visible = not whitespace_visible
  vim.opt.list = whitespace_visible
end
-- toggle whitespace visibility
vim.keymap.set('n', '<leader>tw', toggle_whitespace, { desc = 'Toggle Whitespace Visibility' })
-- Optional: keep whitespace in visual mode
local toggle_whitespace_group = vim.api.nvim_create_augroup('ToggleWhitespaceOnVisual', { clear = true })
vim.api.nvim_create_autocmd('ModeChanged', {
  group = toggle_whitespace_group,
  pattern = '*:[vV]', -- Triggers for Visual (v), Visual Line (V), and Visual Block (<C-v>) modes
  callback = function()
    vim.opt.list = true -- Enable listchars when entering Visual mode
  end,
})
vim.api.nvim_create_autocmd('ModeChanged', {
  group = toggle_whitespace_group,
  pattern = '[vV]:*', -- Triggers when leaving Visual, Visual Line, or Visual Block mode
  callback = function()
    vim.opt.list = whitespace_visible -- Restore listchars based on the global state
  end,
})

-- close all other buffers
_G.close_other_buffers = function()
  local current_buf = vim.api.nvim_get_current_buf()
  local buffers = vim.api.nvim_list_bufs()
  for _, buf in ipairs(buffers) do
    if buf ~= current_buf and vim.api.nvim_buf_is_loaded(buf) then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
end
vim.api.nvim_set_keymap(
  'n', -- Normal mode
  '<Leader>bc', -- Keybinding: <Leader>bc (you can change this)
  ':lua close_other_buffers()<CR>', -- Call the Lua function
  { noremap = true, silent = true } -- Non-recursive and silent
)

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = { '*.cpp', '*.c', '*.h', '*.hpp' }, -- Match C++ source and header files
  callback = function()
    vim.opt_local.shiftwidth = 4 -- Number of spaces per indentation level
    vim.opt_local.tabstop = 4 -- Number of spaces for a tab character
    vim.opt_local.softtabstop = 4 -- Soft tab stop
    vim.opt_local.expandtab = true -- Use spaces instead of tabs
    vim.opt_local.smartindent = true -- Enable smart indentation
    vim.opt_local.autoindent = true -- Copy indentation from the previous line
  end,
})

-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = { "javascriptreact", "typescriptreact", "tsx", "jsx", "javascript", "typescript" },
--   callback = function()
--     vim.opt_local.expandtab = true
--     vim.opt_local.shiftwidth = 2
--     vim.opt_local.tabstop = 2
--     vim.opt_local.softtabstop = 2
--   end,
-- })

--
-- -- Enable break indent
-- vim.o.breakindent = true
--
-- -- Save undo history
-- vim.o.undofile = true
--
-- -- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
-- vim.o.ignorecase = true
-- vim.o.smartcase = true
--
-- -- Keep signcolumn on by default
-- vim.o.signcolumn = 'yes'
--
-- -- Decrease update time
-- vim.o.updatetime = 250
--
-- -- Decrease mapped sequence wait time
-- vim.o.timeoutlen = 300
--
-- -- Configure how new splits should be opened
-- vim.o.splitright = true
-- vim.o.splitbelow = true
--
-- -- Sets how neovim will display certain whitespace characters in the editor.
-- --  See `:help 'list'`
-- --  and `:help 'listchars'`
-- --
-- --  Notice listchars is set using `vim.opt` instead of `vim.o`.
-- --  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
-- --   See `:help lua-options`
-- --   and `:help lua-options-guide`
-- vim.o.list = true
-- vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
--
-- -- Preview substitutions live, as you type!
-- vim.o.inccommand = 'split'
--
-- -- Show which line your cursor is on
-- vim.o.cursorline = true
--
-- -- Minimal number of screen lines to keep above and below the cursor.
-- vim.o.scrolloff = 10
--
-- -- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- -- instead raise a dialog asking if you wish to save the current file(s)
-- -- See `:help 'confirm'`
-- vim.o.confirm = true
--

-- vim: ts=2 sts=2 sw=2 et
