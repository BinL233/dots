-- Overrides merged over nvim-lspconfig's shipped pyright config.
-- Neovim 0.11+ automatically merges `lsp/<server>.lua` from the runtimepath,
-- so this applies regardless of how pyright is enabled.
--
-- Without this, pyright falls back to whatever `python3` is first on PATH,
-- which is Homebrew's interpreter when nvim is launched outside an activated
-- conda shell -- so conda-installed packages report reportMissingImports.

local python = require("config.python")

return {
    -- NOTE: the settings table must be mutated in place. The client captures a
    -- reference to it before `before_init` runs, so reassigning
    -- `config.settings` here would write into a table nothing else can see.
    before_init = function(_, config)
        config.settings = config.settings or {}
        config.settings.python = config.settings.python or {}
        config.settings.python.pythonPath = python.resolve(config.root_dir)
    end,
}
