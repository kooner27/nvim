------------------------------------------------------------
-- Wrap modes: None vs Soft wrap vs Hard wrap
-- Works even when this is the ONLY window (no Neo-tree).
------------------------------------------------------------

-- Default wrap width
local WRAP_WIDTH = 95

-- Tab-scoped pad window bookkeeping
local function close_wrap_pad()
  local pad = vim.t.wrap_pad_win
  if pad and vim.api.nvim_win_is_valid(pad) then
    pcall(vim.api.nvim_win_close, pad, true)
  end
  vim.t.wrap_pad_win = nil
  vim.t.wrap_pad_buf = nil
end

local function ensure_soft_wrap_width(target_width)
  local main_win = vim.api.nvim_get_current_win()
  local wins = vim.api.nvim_tabpage_list_wins(0)

  -- If there are already multiple windows, just resize this one
  if #wins > 1 then
    vim.cmd('vertical resize ' .. target_width)
    return
  end

  -- If our pad already exists, just resize
  if vim.t.wrap_pad_win and vim.api.nvim_win_is_valid(vim.t.wrap_pad_win) then
    vim.api.nvim_set_current_win(main_win)
    vim.cmd('vertical resize ' .. target_width)
    return
  end

  -- Create an invisible pad on the right to absorb remaining width
  vim.cmd 'noautocmd botright vsplit'
  local pad_win = vim.api.nvim_get_current_win()
  local pad_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(pad_win, pad_buf)

  -- Pad buffer opts
  vim.bo[pad_buf].buftype = 'nofile'
  vim.bo[pad_buf].bufhidden = 'wipe'
  vim.bo[pad_buf].swapfile = false
  vim.bo[pad_buf].buflisted = false

  -- Pad window opts (make it invisible/quiet)
  vim.wo[pad_win].winfixwidth = true
  vim.wo[pad_win].number = false
  vim.wo[pad_win].relativenumber = false
  vim.wo[pad_win].signcolumn = 'no'
  vim.wo[pad_win].foldcolumn = '0'
  vim.wo[pad_win].list = false
  vim.wo[pad_win].wrap = false
  vim.wo[pad_win].cursorline = false
  vim.wo[pad_win].statuscolumn = ''
  vim.wo[pad_win].winbar = ''

  vim.t.wrap_pad_win = pad_win
  vim.t.wrap_pad_buf = pad_buf

  -- Back to main window and set its width
  vim.api.nvim_set_current_win(main_win)
  vim.cmd('vertical resize ' .. target_width)
end

-- need to account for gutter in soft wrap mode if you want line numbers
local function get_gutter_width()
  local width = 0

  -- signcolumn (each is ~2 chars wide)
  if vim.wo.signcolumn ~= 'no' then
    local n = tonumber(vim.wo.signcolumn:match ':(%d+)') or 1
    width = width + n * 2
  end

  -- numberwidth (line number column)
  if vim.wo.number or vim.wo.relativenumber then
    width = width + vim.wo.numberwidth
  end

  return width
end

local function set_wrap_mode(mode)
  if mode == 'none' then
    close_wrap_pad()
    vim.opt_local.wrap = false
    vim.opt_local.linebreak = false
    vim.opt_local.breakindent = false
    vim.opt_local.textwidth = 0
    vim.opt_local.colorcolumn = '0'
    vim.opt_local.formatoptions:remove 't'
    vim.opt_local.number = true
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = 'yes'
    print '🔓 No wrap'
  elseif mode == 'soft' then
    local gutter = get_gutter_width()

    ensure_soft_wrap_width(WRAP_WIDTH + gutter)

    -- hide distractions in the main window
    vim.opt_local.number = true
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = 'yes'

    -- soft wrap settings
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true
    vim.opt_local.textwidth = 0
    vim.opt_local.colorcolumn = ''
    vim.opt_local.formatoptions:remove 't'
    print('📜 Soft wrap (' .. WRAP_WIDTH .. ' cols)')
  elseif mode == 'hard' then
    close_wrap_pad()
    vim.opt_local.wrap = false
    vim.opt_local.linebreak = false
    vim.opt_local.breakindent = false
    vim.opt_local.textwidth = WRAP_WIDTH - 1
    vim.opt_local.colorcolumn = tostring(WRAP_WIDTH + 1)
    -- vim.opt_local.colorcolumn = tostring(WRAP_WIDTH + 1)
    vim.opt_local.formatoptions:append 't'
    vim.opt_local.number = true
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = 'yes'
    print('✍️ Hard wrap (' .. WRAP_WIDTH .. ' cols)')
  end
end

-- Commands
vim.api.nvim_create_user_command('WrapNone', function()
  set_wrap_mode 'none'
end, {})
vim.api.nvim_create_user_command('WrapSoft', function()
  set_wrap_mode 'soft'
end, {})
vim.api.nvim_create_user_command('WrapHard', function()
  set_wrap_mode 'hard'
end, {})

-- 🔧 Command to change wrap width dynamically
vim.api.nvim_create_user_command('WrapWidth', function(opts)
  WRAP_WIDTH = tonumber(opts.args) or WRAP_WIDTH
  print('🔧 Wrap width set to ' .. WRAP_WIDTH)
end, { nargs = 1 })

-- Keymaps
vim.keymap.set('n', '<leader>wn', '<cmd>WrapNone<cr>', { desc = 'No wrap' })
vim.keymap.set('n', '<leader>wf', '<cmd>WrapSoft<cr>', { desc = 'Soft wrap' })
vim.keymap.set('n', '<leader>wh', '<cmd>WrapHard<cr>', { desc = 'Hard wrap' })

-- Split-only reflow: break long lines, never join short ones
local function split_only_file()
  local width = vim.o.textwidth
  if width == 0 then
    print 'No textwidth set!'
    return
  end

  local last = vim.fn.line '$'
  for lnum = last, 1, -1 do -- iterate backwards
    local line = vim.fn.getline(lnum)
    if vim.fn.strdisplaywidth(line) > width then
      vim.cmd(lnum .. 'normal! gqq')
    end
  end

  print('✅ Split-only wrap done for whole file at ' .. width)
end

vim.api.nvim_create_user_command('SplitOnlyFile', split_only_file, {})

-- Or keymap
vim.keymap.set('n', '<leader>gq', split_only_file, { desc = 'Hard wrap whole file (split-only)' })

vim.api.nvim_create_user_command('SplitOnlyDir', function(opts)
  local dir = opts.args ~= '' and opts.args or vim.fn.getcwd()
  local files = vim.fn.globpath(dir, '**/*.md', false, true)

  for _, file in ipairs(files) do
    vim.cmd('edit ' .. vim.fn.fnameescape(file))

    -- set hard wrap mode so textwidth & formatoptions are correct
    vim.cmd 'WrapHard'

    -- now apply split-only wrapping
    vim.cmd 'SplitOnlyFile'

    vim.cmd 'write'
    vim.cmd 'bufdo bwipeout' -- close buffers when done
  end

  print('✅ Finished reflowing all .md in ' .. dir)
end, { nargs = '?' })
