-- Set the leader key to Space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Hint: use `:h <option>` to figure out the meaning if needed
vim.opt.clipboard = 'unnamedplus' -- use system clipboard
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
-- vim.opt.mouse = 'a' -- allow the mouse to be used in Nvim

-- Tab
vim.opt.tabstop = 4 -- number of visual spaces per TAB
vim.opt.softtabstop = 4 -- number of spacesin tab when editing
vim.opt.shiftwidth = 4 -- insert 4 spaces on a tab
vim.opt.expandtab = true -- tabs are spaces, mainly because of python

-- UI config
vim.opt.number = true -- show absolute number
vim.opt.relativenumber = true -- add numbers to each line on the left side
vim.opt.cursorline = true -- highlight cursor line underneath the cursor horizontally
vim.opt.scrolloff = 7 -- start scrolling 7 lines before the top/bottom edge
vim.opt.sidescrolloff = 7 -- same, but columns when `nowrap` scrolls horizontally
vim.opt.splitbelow = true -- open new vertical split bottom
vim.opt.splitright = true -- open new horizontal splits right
-- vim.opt.termguicolors = true        -- enabl 24-bit RGB color in the TUI
vim.opt.showmode = false -- we are experienced, wo don't need the "-- INSERT --" mode hint

-- Searching
vim.opt.incsearch = true -- search as characters are entered
vim.opt.hlsearch = false -- do not highlight matches
vim.opt.ignorecase = true -- ignore case in searches by default
vim.opt.smartcase = true -- but make it case sensitive if an uppercase is entered

-- views can only be fully collapsed with the global statusline
vim.opt.laststatus = 3

-- Filetype detection
vim.filetype.add({
    extension = {
        gotmpl = 'gotmpl',
    },
})

-- Diagnostic sign icons
local diagnostics_icons = require('icons').get('diagnostics')

vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = diagnostics_icons.Error,
            [vim.diagnostic.severity.WARN] = diagnostics_icons.Warning,
            [vim.diagnostic.severity.INFO] = diagnostics_icons.Information,
            [vim.diagnostic.severity.HINT] = diagnostics_icons.Hint,
        },
    },
})

-- LSP auto formatting
-- Create an augroup to manage the autocmd cleanly
local lsp_fmt_group = vim.api.nvim_create_augroup('LspFormattingGroup', {})

-- Create the format-on-save autocmd
vim.api.nvim_create_autocmd('BufWritePre', {
  group = lsp_fmt_group,
  callback = function(ev)
    -- Using async = false ensures the formatting finishes before the file saves
    vim.lsp.buf.format({
        bufnr = ev.buf,
        async = false
    })
  end,
})
