-- Basic settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.mouse = 'a'
vim.opt.clipboard = 'unnamedplus'

-- Set leader key
-- vim.g.mapleader = ' '

-- Keymaps
-- vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<CR>')

require("config.lazy")
