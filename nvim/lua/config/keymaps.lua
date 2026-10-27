local vscode = require('config/vscode')

-- define common options
local opts = {
    noremap = true, -- non-recursive
    silent = true,  -- do not show message
}

-----------------
-- Normal mode --
-----------------

-- Hint: see `:h vim.map.set()`
-- Better window navigation is handled by vim-tmux-navigator plugin
-- vim.keymap.set('n', '<C-h>', '<C-w>h', opts)
-- vim.keymap.set('n', '<C-j>', '<C-w>j', opts)
-- vim.keymap.set('n', '<C-k>', '<C-w>k', opts)
-- vim.keymap.set('n', '<C-l>', '<C-w>l', opts)

-- Resize with arrows
-- delta: 2 lines
vim.keymap.set('n', '<C-Up>', ':resize -2<CR>', opts)
vim.keymap.set('n', '<C-Down>', ':resize +2<CR>', opts)
vim.keymap.set('n', '<C-Left>', ':vertical resize -2<CR>', opts)
vim.keymap.set('n', '<C-Right>', ':vertical resize +2<CR>', opts)

-- Nvim Tree
if vscode.has("nvim-tree.lua") then
    vim.keymap.set("n", "<leader>t", ":NvimTreeToggle<CR>", { silent = true })
end

-- Diffview
if vscode.has("diffview.nvim") then
    vim.keymap.set("n", "<leader>d", function()
        local lib = require("diffview.lib")
        local view = lib.get_current_view()

        if view then
            vim.cmd("DiffviewClose")
        else
            vim.cmd("DiffviewOpen")
        end
    end, { desc = "Toggle Diffview" })
end

-----------------
-- Visual mode --
-----------------

-- Hint: start visual mode with the same area as the previous area and the same mode
vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', '>', '>gv', opts)

-- Telescope
if vscode.has("telescope.nvim") then
    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
    vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
end

-- barbar
if vscode.has("barbar.nvim") then
    vim.keymap.set('n', '<A-,>', '<Cmd>BufferPrevious<CR>', opts)
    vim.keymap.set('n', '<A-.>', '<Cmd>BufferNext<CR>', opts)
    vim.keymap.set('n', '<A-c>', '<Cmd>BufferClose<CR>', opts)
end

-- Go to Definition
-- Jump to definition
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to Definition' })
-- Jump back from definition
vim.keymap.set('n', 'gb', '<C-t>', { desc = 'Go Back from Definition' })

-- Open definition in a vertical split (handy!)
vim.keymap.set('n', 'gv', function()
    vim.cmd('vsplit')
    vim.lsp.buf.definition()
end, { desc = 'Go to Definition in Split' })

-- Outline
if vscode.has("outline.nvim") then
    vim.keymap.set("n", "<leader>o", "<cmd>Outline<CR>", { desc = "Toggle Outline" })
end

-- LSP Display diagnostics (VSCode renders its own inline diagnostics)
if not vscode.enabled then
    vim.api.nvim_create_autocmd("CursorHold", {
        buffer = bufnr,
        callback = function()
            local opts = {
                focusable = false,
                close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
                border = 'rounded',
                source = 'always',
                prefix = ' ',
                scope = 'cursor',
            }
            vim.diagnostic.open_float(nil, opts)
        end
    })
end

-- Lspsaga
if vscode.has("lspsaga.nvim") then
    vim.keymap.set('n', '<leader>lc', "<cmd>Lspsaga code_action<CR>", { desc = "Lspsaga code_action" })
    vim.keymap.set('n', '<leader>li', "<cmd>Lspsaga incoming_calls<CR>", { desc = "Lspsaga incoming_calls" })
    vim.keymap.set('n', '<leader>lo', "<cmd>Lspsaga outgoing_calls<CR>", { desc = "Lspsaga outgoing_calls" })
    vim.keymap.set('n', '<leader>ld', "<cmd>Lspsaga peek_definition<CR>", { desc = "Lspsaga peek_definition" })
    vim.keymap.set('n', '<leader>lt', "<cmd>Lspsaga term_toggle<CR>", { desc = "Lspsaga term_toggle" })
end

-- Neogit
if vscode.has("neogit") then
    vim.keymap.set('n', "<leader>dd", "<cmd>Neogit<cr>", { desc = "Show Neogit UI" })
end

-----------------------------------------------------------------------
-- VSCode replacements for the keymaps above that need a disabled plugin
-----------------------------------------------------------------------
local code_ok, code = pcall(require, 'vscode')

if vscode.enabled and code_ok then
    local function action(name, desc)
        return function() code.action(name) end, { desc = desc }
    end

    -- File explorer / outline / fuzzy finding: VSCode's own views
    vim.keymap.set('n', '<leader>t', action('workbench.view.explorer', 'Explorer'))
    vim.keymap.set('n', '<leader>o', action('outline.focus', 'Outline'))
    vim.keymap.set('n', '<leader>ff', action('workbench.action.quickOpen', 'Find files'))
    vim.keymap.set('n', '<leader>fg', action('workbench.action.findInFiles', 'Live grep'))
    vim.keymap.set('n', '<leader>fb', action('workbench.action.showAllEditors', 'Buffers'))

    -- Buffer (editor tab) cycling, mirroring the barbar maps
    vim.keymap.set('n', '<A-,>', action('workbench.action.previousEditor', 'Previous editor'))
    vim.keymap.set('n', '<A-.>', action('workbench.action.nextEditor', 'Next editor'))
    vim.keymap.set('n', '<A-c>', action('workbench.action.closeActiveEditor', 'Close editor'))

    -- Git: SCM view and diff, mirroring the Neogit / Diffview maps
    vim.keymap.set('n', '<leader>d', action('workbench.view.scm', 'Source control'))
    vim.keymap.set('n', '<leader>dd', action('workbench.view.scm', 'Source control'))

    -- LSP actions, mirroring the Lspsaga maps
    vim.keymap.set('n', '<leader>lc', action('editor.action.quickFix', 'Code action'))
    vim.keymap.set('n', '<leader>li', action('references-view.showIncomingCalls', 'Incoming calls'))
    vim.keymap.set('n', '<leader>lo', action('references-view.showOutgoingCalls', 'Outgoing calls'))
    vim.keymap.set('n', '<leader>ld', action('editor.action.peekDefinition', 'Peek definition'))
    vim.keymap.set('n', '<leader>lt', action('workbench.action.terminal.toggleTerminal', 'Toggle terminal'))

    -- Definition navigation: VSCode's LSP, not Neovim's (no clients attached)
    vim.keymap.set('n', 'gd', action('editor.action.revealDefinition', 'Go to definition'))
    vim.keymap.set('n', 'gb', action('workbench.action.navigateBack', 'Go back'))
    vim.keymap.set('n', 'gv', action('editor.action.revealDefinitionAside', 'Definition to the side'))
    vim.keymap.set('n', 'gr', action('editor.action.goToReferences', 'Go to references'))
    vim.keymap.set('n', 'K', action('editor.action.showHover', 'Hover'))

    -- Markdown preview, mirroring the vellum map
    vim.keymap.set('n', '<leader>mp', action('markdown.showPreviewToSide', 'Markdown preview'))
end
