local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

local vscode = require('config/vscode')

require('config/options')
require("lazy").setup({
    spec = {
        { import = "plugins" }
    },
    -- Under vscode-neovim, skip plugins that duplicate or conflict with the
    -- editor's own UI (see lua/config/vscode.lua).
    defaults = {
        cond = vscode.cond,
    },
})

vim.opt.updatetime = 500

require('config/keymaps')
require('config/treesitter-config')

if not vscode.enabled then
    require('config/colortheme')
end
