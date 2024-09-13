vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.opt.wrap=false
vim.g.mapleader = " "
-- ------- keybindings
-- Map Ctrl + S to save the current file. we disabled ctrl s in bashrc
vim.keymap.set('n', '<C-s>', ':wa<CR>', { noremap = true, silent = false })
vim.keymap.set('i', '<C-s>', '<C-o>:wa<CR>', { noremap = true, silent = false })
--vim.keymap.set('n', '<C-s>', ':w<CR>', { noremap = true, silent = false })
--vim.keymap.set('i', '<C-s>', '<C-o>:w<CR>', { noremap = true, silent = false })
vim.opt.clipboard = 'unnamedplus'
vim.api.nvim_set_keymap('n', '<leader>p', ':set paste<CR>"+p:set nopaste<CR>:%s/\\r//g<CR>', { noremap = true, silent = true })



-- vim.api.nvim_set_keymap('v', '<C-k>', '<Esc>', { noremap = true, silent = true })

-- ctrl j for switching modes
-- vim.api.nvim_set_keymap('i', '<C-k>', '<Esc>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<C-k>', 'i', { noremap = true, silent = true })
-------------

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
