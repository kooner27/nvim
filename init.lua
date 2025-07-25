-- Global indentation settings
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.smartindent = true
vim.opt.autoindent = true

vim.opt.wrap = false
vim.g.mapleader = " "

-- Show tabline when there are multiple tabs
vim.opt.number = true
vim.opt.scrolloff = 10

-- change default split global and for copilot (right instead of left)
vim.opt.splitright = true
-- also for copilot
vim.opt.completeopt = { "menu", "menuone", "noinsert", "noselect", "popup" }
-- disable copilot auto completion, i want it just to be the backend for chat
vim.g.copilot_enabled = false
vim.g.copilot_filetypes = { ["*"] = false }

-- highlight current line
vim.opt.cursorline = true

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

---- Keybindings
-- Map Ctrl + S to save the current file. we disabled ctrl s in bashrc
vim.keymap.set("n", "<C-s>", ":wa<CR>", { noremap = true, silent = false })
vim.keymap.set("i", "<C-s>", "<C-o>:wa<CR>", { noremap = true, silent = false })
-- vim.keymap.set('n', '<C-s>', ':w<CR>', { noremap = true, silent = false })
-- vim.keymap.set('i', '<C-s>', '<C-o>:w<CR>', { noremap = true, silent = false })
vim.opt.clipboard = "unnamedplus"
vim.api.nvim_set_keymap(
  "n",
  "<leader>p",
  -- ':set paste<CR>"+p:set nopaste<CR>:%s/\\r//g<CR>',
  ':set paste<CR>"+p:set nopaste<CR>',
  { noremap = true, silent = true }
)

-- Remove auto comment formatting stuff
-- Remove 'c', 'r', and 'o' from formatoptions globally
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove("c")
    vim.opt_local.formatoptions:remove("r")
    vim.opt_local.formatoptions:remove("o")
  end,
})

-- see whitespace
-- Configure listchars for displaying whitespace characters
vim.opt.listchars = {
  space = "·",
  tab = "→ ",
  trail = "·",
  extends = ">",
  precedes = "<",
  nbsp = "␣",
}

-- Track the global whitespace visibility state
local whitespace_visible = false

-- Function to toggle whitespace visibility
local function toggle_whitespace()
  whitespace_visible = not whitespace_visible
  vim.opt.list = whitespace_visible
end

-- Map a keybinding to toggle whitespace visibility
vim.keymap.set("n", "<leader>tw", toggle_whitespace, { desc = "Toggle Whitespace Visibility" })

-- Optional: keep Visual mode autocmds if you want automatic whitespace visibility in Visual mode
local toggle_whitespace_group = vim.api.nvim_create_augroup("ToggleWhitespaceOnVisual", { clear = true })
vim.api.nvim_create_autocmd("ModeChanged", {
  group = toggle_whitespace_group,
  pattern = "*:[vV]", -- Triggers for Visual (v), Visual Line (V), and Visual Block (<C-v>) modes
  callback = function()
    vim.opt.list = true -- Enable listchars when entering Visual mode
  end,
})
vim.api.nvim_create_autocmd("ModeChanged", {
  group = toggle_whitespace_group,
  pattern = "[vV]:*", -- Triggers when leaving Visual, Visual Line, or Visual Block mode
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

-- Map the function to a keybinding
vim.api.nvim_set_keymap(
  "n", -- Normal mode
  "<Leader>bo", -- Keybinding: <Leader>bo
  ":lua close_other_buffers()<CR>", -- Call the global function
  { noremap = true, silent = true } -- Non-recursive and silent
)

-- Map the function to a keybinding
vim.api.nvim_set_keymap(
  "n", -- Normal mode
  "<Leader>bc", -- Keybinding: <Leader>bo (you can change this)
  ":lua close_other_buffers()<CR>", -- Call the Lua function
  { noremap = true, silent = true } -- Non-recursive and silent
)

-- c++ indentation, set this and that clang-format to size 4 indents, can change this later
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.cpp", "*.c", "*.h", "*.hpp" }, -- Match C++ source and header files
  callback = function()
    vim.opt_local.shiftwidth = 4 -- Number of spaces per indentation level
    vim.opt_local.tabstop = 4 -- Number of spaces for a tab character
    vim.opt_local.softtabstop = 4 -- Soft tab stop
    vim.opt_local.expandtab = true -- Use spaces instead of tabs
    vim.opt_local.smartindent = true -- Enable smart indentation
    vim.opt_local.autoindent = true -- Copy indentation from the previous line
  end,
})
--
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = { "javascriptreact", "typescriptreact", "tsx", "jsx", "javascript", "typescript" },
--   callback = function()
--     vim.opt_local.expandtab = true
--     vim.opt_local.shiftwidth = 2
--     vim.opt_local.tabstop = 2
--     vim.opt_local.softtabstop = 2
--   end,
-- })

-- Text wrap toggle
-- vim.keymap.set("n", "<leader>w", function()
-- 	-- Toggle wrap
-- 	if vim.wo.wrap then
-- 		vim.wo.wrap = false
-- 		vim.wo.textwidth = 0 -- Remove textwidth when wrap is off
-- 	else
-- 		vim.wo.wrap = true
-- 		vim.wo.textwidth = 100 -- Set textwidth to 100 when wrap is on
-- 	end
-- end, { desc = "Toggle wrap at 100 characters" })
-- toggle terminal opens termina in buffer so you get error if you wqa

-- vim.api.nvim_set_keymap('v', '<C-k>', '<Esc>', { noremap = true, silent = true })
-- ctrl j for switching modes
-- vim.api.nvim_set_keymap('i', '<C-k>', '<Esc>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<C-k>', 'i', { noremap = true, silent = true })

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- lazy import and setup
require("lazy").setup("plugins")
