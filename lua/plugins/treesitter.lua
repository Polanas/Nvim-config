require("nvim-treesitter.install").prefer_git = true

vim.filetype.add({ extension = { wgsl = "wgsl" } })
-- local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
-- parser_config.wgsl = {
--     install_info = {
--         url = "https://github.com/szebniok/tree-sitter-wgsl",
--         files = { "src/parser.c" }
--     },
-- }

require 'nvim-treesitter.configs'.setup {
    ensure_installed = { "lua", "rust", "c", "python", "wgsl" },
    highlight = {
        enable = true
    },
    sync_install = false,
    auto_install = true,
    incremental_selection = { enable = true },
    textobjects = { enable = true },
    indent = { enable = false }
}

require("nvim-treesitter.install").prefer_git = true
