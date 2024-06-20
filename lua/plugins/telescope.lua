local actions = require("telescope.actions")
require("telescope").setup {
    defaults = {
        -- mappings = {
        --     i = {
        --         ["<C-a>"] = actions.results_scrolling_left,
        --         ["<C-e>"] = actions.results_scrolling_right,
        --     }
        -- },
        preview = false,
    },
    preview = false,
    pickers = {
        colorscheme = {
            enable_preview = true
        }
    }
}

-- telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fw', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fr', builtin.lsp_references, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>gb', builtin.git_branches, {})
vim.keymap.set('n', '<leader>gc', builtin.git_commits, {})
vim.keymap.set('n', '<leader>Gs', builtin.git_status, {})
vim.keymap.set('n', '<leader>ps', builtin.lsp_document_symbols, {})
vim.keymap.set('n', '<leader>is', builtin.lsp_workspace_symbols, {})
