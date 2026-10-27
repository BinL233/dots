-- Python interpreter configuration for LSP servers.
-- Interpreter paths live here rather than inline in LSP setup so there is a
-- single place to change them.

local M = {}

-- Interpreter used when nothing better is detected. Points at the conda `base`
-- environment, which is where globally-installed packages (anthropic,
-- python-dotenv, ...) are kept.
M.default_python = vim.fn.expand("~/miniconda3/bin/python")

-- Project-local virtualenv directory names, probed in this order.
M.venv_dirs = { ".venv", "venv", "env" }

-- Conda install directories whose interpreter means the `base` environment.
M.conda_roots = { "miniconda3", "anaconda3", "miniforge3" }

-- Prefix shown in the statusline component.
M.icon = "󰌠 "

--- Resolve the interpreter pyright should use for a project.
--- Precedence: project-local venv > activated env > configured default.
--- @param root string|nil project root directory
--- @return string path to a python executable
function M.resolve(root)
    if root then
        for _, dir in ipairs(M.venv_dirs) do
            local candidate = root .. "/" .. dir .. "/bin/python"
            if vim.uv.fs_stat(candidate) then
                return candidate
            end
        end
    end

    local prefix = vim.env.VIRTUAL_ENV or vim.env.CONDA_PREFIX
    if prefix and vim.uv.fs_stat(prefix .. "/bin/python") then
        return prefix .. "/bin/python"
    end

    return M.default_python
end

--- Interpreter actually in use for a buffer.
--- Reads it off the running pyright client so the display reflects what the
--- LSP is really doing, rather than re-running the guess.
--- @param bufnr integer|nil
--- @return string|nil path, boolean live  -- live is false when no client is attached
function M.current(bufnr)
    bufnr = bufnr or 0
    for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr, name = "pyright" })) do
        local path = vim.tbl_get(client.settings or {}, "python", "pythonPath")
        if path then
            return path, true
        end
    end
    return M.resolve(vim.fn.getcwd()), false
end

--- Short env name for display, e.g. "base", "myenv", ".venv".
--- @param bufnr integer|nil
--- @return string
function M.label(bufnr)
    local path = M.current(bufnr)
    if not path then
        return ""
    end
    -- .../<env>/bin/python -> <env>
    local env = vim.fs.basename(vim.fs.dirname(vim.fs.dirname(path)))
    if vim.tbl_contains(M.conda_roots, env) then
        env = "base"
    end
    return M.icon .. env
end

--- An activated environment that was skipped because it has no interpreter.
--- Usually means the env was created without python, e.g.
--- `conda create -n foo` instead of `conda create -n foo python=3.12`.
--- @return string|nil prefix
function M.skipped_env()
    local prefix = vim.env.VIRTUAL_ENV or vim.env.CONDA_PREFIX
    if prefix and not vim.uv.fs_stat(prefix .. "/bin/python") then
        return prefix
    end
end

vim.api.nvim_create_user_command("PythonEnv", function()
    local path, live = M.current(0)
    local origin = live and "pyright client" or "resolved (no client attached)"
    local msg = ("%s\nsource: %s"):format(path, origin)

    local skipped = M.skipped_env()
    if skipped then
        vim.notify(
            ("%s\n\nNOTE: $%s points at\n  %s\nbut it has no bin/python, so it was skipped.\nCreate it with a python package, e.g.\n  conda install -n %s python=3.12"):format(
                msg,
                vim.env.VIRTUAL_ENV and "VIRTUAL_ENV" or "CONDA_PREFIX",
                skipped,
                vim.fs.basename(skipped)
            ),
            vim.log.levels.WARN,
            { title = "Python env" }
        )
    else
        vim.notify(msg, vim.log.levels.INFO, { title = "Python env" })
    end
end, { desc = "Show the Python interpreter pyright is using" })

return M
