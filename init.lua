vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.opt.wrap = false
vim.g.mapleader = " "

-- Show tabline when there are multiple tabs
vim.opt.number = true
vim.opt.scrolloff = 10

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

---- Keybindings
-- Map Ctrl + S to save the current file. we disabled ctrl s in bashrc
vim.keymap.set("n", "<C-s>", ":wa<CR>", { noremap = true, silent = false })
vim.keymap.set("i", "<C-s>", "<C-o>:wa<CR>", { noremap = true, silent = false })
--vim.keymap.set('n', '<C-s>', ':w<CR>', { noremap = true, silent = false })
--vim.keymap.set('i', '<C-s>', '<C-o>:w<CR>', { noremap = true, silent = false })
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
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
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
