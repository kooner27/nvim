------------------------------------------------------------
-- Wrap modes: None vs Soft wrap vs Hard wrap (95 cols)
-- Works even when this is the ONLY window (no Neo-tree).
------------------------------------------------------------
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
    vim.cmd("vertical resize " .. target_width)
    return
  end

  -- If our pad already exists, just resize
  if vim.t.wrap_pad_win and vim.api.nvim_win_is_valid(vim.t.wrap_pad_win) then
    vim.api.nvim_set_current_win(main_win)
    vim.cmd("vertical resize " .. target_width)
    return
  end

  -- Create an invisible pad on the right to absorb remaining width
  vim.cmd("noautocmd botright vsplit")
  local pad_win = vim.api.nvim_get_current_win()
  local pad_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(pad_win, pad_buf)

  -- Pad buffer opts
  vim.bo[pad_buf].buftype = "nofile"
  vim.bo[pad_buf].bufhidden = "wipe"
  vim.bo[pad_buf].swapfile = false
  vim.bo[pad_buf].buflisted = false

  -- Pad window opts (make it invisible/quiet)
  vim.wo[pad_win].winfixwidth = true
  vim.wo[pad_win].number = false
  vim.wo[pad_win].relativenumber = false
  vim.wo[pad_win].signcolumn = "no"
  vim.wo[pad_win].foldcolumn = "0"
  vim.wo[pad_win].list = false
  vim.wo[pad_win].wrap = false
  vim.wo[pad_win].cursorline = false
  vim.wo[pad_win].statuscolumn = ""
  vim.wo[pad_win].winbar = ""

  vim.t.wrap_pad_win = pad_win
  vim.t.wrap_pad_buf = pad_buf

  -- Back to main window and set its width
  vim.api.nvim_set_current_win(main_win)
  vim.cmd("vertical resize " .. target_width)
end

local function set_wrap_mode(mode)
  if mode == "none" then
    close_wrap_pad()
    vim.opt_local.wrap = false
    vim.opt_local.linebreak = false
    vim.opt_local.breakindent = false
    vim.opt_local.textwidth = 0
    vim.opt_local.colorcolumn = "0"
    vim.opt_local.formatoptions:remove("t")
    vim.opt_local.number = true
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "yes"
    print("🔓 No wrap")
  elseif mode == "soft" then
    ensure_soft_wrap_width(95)

    -- hide distractions in the main window
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"

    -- soft wrap settings
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true
    vim.opt_local.textwidth = 0
    vim.opt_local.colorcolumn = ""
    vim.opt_local.formatoptions:remove("t")
    print("📜 Soft wrap (95 cols)")
  elseif mode == "hard" then
    close_wrap_pad()
    vim.opt_local.wrap = false
    vim.opt_local.linebreak = false
    vim.opt_local.breakindent = false
    vim.opt_local.textwidth = 95
    vim.opt_local.colorcolumn = "96"
    vim.opt_local.formatoptions:append("t")
    vim.opt_local.number = true
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "yes"
    print("✍️ Hard wrap (95 cols)")
  end
end

-- Commands
vim.api.nvim_create_user_command("WrapNone", function()
  set_wrap_mode("none")
end, {})
vim.api.nvim_create_user_command("WrapSoft", function()
  set_wrap_mode("soft")
end, {})
vim.api.nvim_create_user_command("WrapHard", function()
  set_wrap_mode("hard")
end, {})

-- Keymaps
vim.keymap.set("n", "<leader>wn", "<cmd>WrapNone<cr>", { desc = "No wrap" })
vim.keymap.set("n", "<leader>wf", "<cmd>WrapSoft<cr>", { desc = "Soft wrap (95)" })
vim.keymap.set("n", "<leader>wh", "<cmd>WrapHard<cr>", { desc = "Hard wrap at 95" })
