local function my_on_attach(bufnr)
    local api = require("nvim-tree.api")

    local function opts(desc)
        return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    api.config.mappings.default_on_attach(bufnr)
    vim.keymap.set('n', '.', api.tree.change_root_to_node, opts('CD'))
end
vim.fn.sign_define("DiagnosticSignError",
    { text = " ", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn",
    { text = " ", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo",
    { text = " ", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint",
    { text = "󰌵", texthl = "DiagnosticSignHint" })

local gwidth = vim.api.nvim_list_uis()[1].width
local gheight = vim.api.nvim_list_uis()[1].height
local width = 30
local height = 30

require('nvim-tree').setup {
    on_attach = my_on_attach,
    disable_netrw = true,
    view = {
        float = {
            enable = false,
            open_win_config = {
                relative = "editor",
                width = width,
                height = height,
                row = (gheight - height) * 0.5,
                col = (gwidth - width) * 0.5,
            }
        },
        relativenumber = true,
        adaptive_size = true,
    },
    actions = {
        change_dir = {
            global = true
        }
    },
    sync_root_with_cwd = true,
    notify = {
        threshold = vim.log.levels.WARN
    },
    filesystem_watchers = {
        ignore_dirs = {
            "target",
            "debug"
        }
    }
}
