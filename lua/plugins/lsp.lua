local function gdshader()
    vim.lsp.start {
        name = "gdshader-lsp",
        cmd = {
            "/home/palas/Documents/bin/gdshader-lsp",
        },
        capabilities = vim.lsp.protocol.make_client_capabilities()
    }
end

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*.gdshader",
    callback = function()
        gdshader()
    end
})
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = "*.wgsl",
    callback = function()
        vim.bo.filetype = "wgsl"
    end,
})

-- Setup language servers.
local lspconfig = require('lspconfig')
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        update_in_insert = false,
    }
)

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
lspconfig.html.setup {
    capabilities = capabilities,

    lspconfig.taplo.setup {}
}
lspconfig.teal_ls.setup {}
lspconfig.jsonls.setup {}
lspconfig.wgsl_analyzer.setup {}
lspconfig.pylsp.setup {}
lspconfig.zls.setup {}
lspconfig.glslls.setup {
    cmd = { 'glslls', '--stdin', '--target-env', 'opengl' },
}
vim.filetype.add({
    extension = {
        vert = "glsl",
        frag = "glsl",
        geom = "glsl",
        comp = "glsl",
        tesc = "glsl"
    }
})
-- lspconfig.rust_analyzer.setup {}
-- Server-specific settings. See `:help lspconfig-setup`
lspconfig.lua_ls.setup {
    settings = {
        Lua = {
            completion = {
                callSnippet = "Replace"
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
            },
            diagnostics = {
                globals = {
                    "vim"
                }
            },
        }
    }
}
-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', '<C-space>', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set('n', '<space>F', function()
            if vim.bo.filetype == "gdscript" then
                require("conform").format({ async = true })
                return
            end

            vim.lsp.buf.format()
            require("conform").setup({
                formatters_by_ft = {
                    lua = { "stylua" },
                    -- Conform will run multiple formatters sequentially
                    python = { "isort", "black" },
                    -- Use a sub-list to run only the first available formatter
                    javascript = { { "prettierd", "prettier" } },
                },
            })
        end, opts)
        vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        vim.keymap.set('n', '<space>td', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<space>f', function()
            vim.lsp.buf.format { async = true }
        end, opts)
    end,
})
if FormatOnInsertLeave then
    vim.api.nvim_create_autocmd({ 'InsertLeave' }, {
        callback = function()
            local file_type = vim.bo.filetype;

            local client = vim.lsp.get_active_clients()[1]
            if client == nil then
                return
            end
            if not client.supports_method("textDocument/formatting") then
                return
            end

            for _, value in ipairs(ExcludedLspFilePathes) do
                if file_type == value then
                    return
                end
            end

            vim.fn.timer_start(20, function()
                vim.lsp.buf.format({ async = true })
            end)
        end,
    })
end
