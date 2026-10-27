-- Shared VSCode (vscode-neovim) detection and plugin gating.
--
-- vscode-neovim drives Neovim as an embedded engine: it owns the cmdline,
-- messages, popupmenu, statusline, tabline, gutter and completion via
-- `ext_*` UI options. Any plugin that draws its own version of those fights
-- the editor (Noice outright refuses to start), so they are switched off here
-- and VSCode's native equivalent is used instead.
local M = {}

M.enabled = vim.g.vscode ~= nil

-- Plugins replaced by VSCode's own UI, or that cannot work under `ext_*`.
local disabled = {
    -- cmdline / messages / notifications
    "noice.nvim",
    "nui.nvim",
    "nvim-notify",
    -- statusline / tabline / explorer / outline
    "lualine.nvim",
    "barbar.nvim",
    "nvim-tree.lua",
    "outline.nvim",
    -- gutter, scrollbar and cursor eye-candy
    "gitsigns.nvim",
    "nvim-scrollbar",
    "smear-cursor.nvim",
    "neoscroll.nvim",
    "indent-blankline.nvim",
    "nvim-colorizer.lua",
    "nvim-treesitter-context",
    "nvim-ts-rainbow2",
    -- colorschemes: VSCode's theme paints the buffer
    "tokyonight.nvim",
    "monokai.nvim",
    -- completion / snippets: VSCode IntelliSense owns this
    "blink.cmp",
    "friendly-snippets",
    "LuaSnip",
    "lspkind.nvim",
    -- LSP: VSCode's own language servers already run
    "mason.nvim",
    "mason-lspconfig.nvim",
    "nvim-lspconfig",
    "lspsaga.nvim",
    -- floating-window git UIs: use VSCode's SCM view
    "diffview.nvim",
    "neogit",
    -- pickers and popups replaced by the command palette / quick open
    "telescope.nvim",
    "telescope-fzf-native.nvim",
    "which-key.nvim",
    -- no tmux pane to navigate to
    "vim-tmux-navigator",
    -- markdown preview is a VSCode built-in
    "markdown-preview.nvim",
    "vellum.nvim",
}

local disabled_set = {}
for _, name in ipairs(disabled) do
    disabled_set[name] = true
end

--- lazy.nvim `defaults.cond` predicate: false keeps the plugin unloaded.
--- @param plugin table lazy.nvim plugin spec
function M.cond(plugin)
    if not M.enabled then
        return true
    end
    return not disabled_set[plugin.name]
end

--- True when `name` is usable in the current frontend.
--- @param name string plugin directory name, e.g. "telescope.nvim"
function M.has(name)
    return not (M.enabled and disabled_set[name])
end

return M
