-- ~/.config/nvim/init.lua

-- ============================================================
-- Plugins
-- ============================================================
vim.pack.add({
  {
    src  = 'https://github.com/catppuccin/nvim',
    name = 'catppuccin',
  },
})

-- Configure and apply the theme
require('catppuccin').setup({
  flavour = 'macchiato', -- latte | frappe | macchiato | mocha
  background = {
    light = 'latte',
    dark  = 'macchiato',
  },
  transparent_background = false,
})

vim.cmd.colorscheme('catppuccin')

-- ============================================================
-- UI
-- ============================================================
vim.opt.number         = true   -- absolute line number on current line
vim.opt.relativenumber = true   -- relative numbers on all other lines
vim.opt.signcolumn     = 'yes'  -- always show sign column (avoids layout shifts)
vim.opt.cursorline     = true   -- highlight the current line
vim.opt.wrap           = false  -- don't wrap long lines
vim.opt.scrolloff      = 8      -- keep 8 lines visible above/below cursor
vim.opt.sidescrolloff  = 8      -- keep 8 columns visible left/right of cursor
vim.opt.termguicolors  = true   -- 24-bit RGB colours (required for catppuccin)
vim.opt.showmode       = false  -- mode is already shown by a statusline plugin

-- ============================================================
-- Indentation
-- ============================================================
vim.opt.tabstop     = 2      -- a <Tab> counts as 2 spaces visually
vim.opt.shiftwidth  = 2      -- >> and << shift by 2 spaces
vim.opt.expandtab   = true   -- insert spaces instead of tab characters
vim.opt.smartindent = true   -- auto-indent new lines based on context

-- ============================================================
-- Search
-- ============================================================
vim.opt.ignorecase = true   -- case-insensitive search…
vim.opt.smartcase  = true   -- …unless you type a capital letter
vim.opt.hlsearch   = false  -- don't keep matches highlighted after search
vim.opt.incsearch  = true   -- highlight as you type

-- ============================================================
-- Files & undo
-- ============================================================
vim.opt.swapfile = false                                       -- no .swp files
vim.opt.backup   = false                                       -- no ~ backup files
vim.opt.undofile = true                                        -- persist undo history across sessions
vim.opt.undodir  = os.getenv('HOME') .. '/.vim/undodir'       -- undo history location

-- ============================================================
-- Splits
-- ============================================================
vim.opt.splitright = true   -- vertical splits open to the right
vim.opt.splitbelow = true   -- horizontal splits open below

-- ============================================================
-- Clipboard
-- ============================================================
vim.opt.clipboard = 'unnamedplus'   -- use macOS system clipboard by default

-- ============================================================
-- Keymaps
-- ============================================================
vim.g.mapleader = ' '   -- space as leader key

local map = function(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, desc = desc })
end

-- Clear search highlight
map('n', '<Esc>', '<cmd>nohlsearch<CR>', 'Clear search highlight')

-- Move selected lines up/down in visual mode
map('v', 'J', ":m '>+1<CR>gv=gv", 'Move selection down')
map('v', 'K', ":m '<-2<CR>gv=gv", 'Move selection up')

-- Keep cursor centred when jumping
map('n', '<C-d>', '<C-d>zz', 'Scroll down (centred)')
map('n', '<C-u>', '<C-u>zz', 'Scroll up (centred)')

-- Better split navigation
map('n', '<C-h>', '<C-w>h', 'Move to left split')
map('n', '<C-j>', '<C-w>j', 'Move to lower split')
map('n', '<C-k>', '<C-w>k', 'Move to upper split')
map('n', '<C-l>', '<C-w>l', 'Move to right split')
