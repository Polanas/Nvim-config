local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git", "--branch=stable", -- latest stable release
        lazypath
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000
    },
    { "EdenEast/nightfox.nvim" },
    { "folke/tokyonight.nvim" },
    { "kepano/flexoki-neovim" },
    { "diegoulloao/neofusion.nvim" },
    { "nyoom-engineering/oxocarbon.nvim" },
    { "navarasu/onedark.nvim" },
    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        config = true,
        opts = ...
    },
    { "rebelot/kanagawa.nvim" },
    {
        "andrewferrier/debugprint.nvim",
        dependencies = {
            "echasnovski/mini.nvim"
        },
        config = function()
            require("debugprint").setup()
        end
    },
    {
        "vidocqh/auto-indent.nvim",
        enabled = false
    },
    {
        "tyru/open-browser.vim",
        lazy = false
    },
    { "svermeulen/text-to-colorscheme" },
    {
        "archibate/lualine-time",
        enabled = false
    },
    { "akinsho/toggleterm.nvim" },
    {
        "romainl/vim-cool",
        lazy = false
    },
    {
        "fedepujol/move.nvim",
        config = function()
            require("move").setup {}
        end
    },
    {
        "lvimuser/lsp-inlayhints.nvim",
        config = function()
            require("lsp-inlayhints").setup {
                inlay_hints = {
                    highlight = "Comment"
                }
            }
        end
    },
    { 'phaazon/hop.nvim' },
    {
        'nvim-zh/colorful-winsep.nvim',
        enabled = false,
        config = function()
            require("colorful-winsep").setup()
        end,
        event = { "WinNew" },
    },
    {
        "terryma/vim-multiple-cursors",
        lazy = false,
        enabled = false
    },
    {
        "nvim-neotest/neotest",
        lazy = false,
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter"
        }
    },
    {
        "smoka7/multicursors.nvim",
        event = "VeryLazy",
        dependencies = {
            'smoka7/hydra.nvim',
        },
        opts = {},
        cmd = { 'MCstart', 'MCvisual', 'MCclear', 'MCpattern', 'MCvisualPattern', 'MCunderCursor' },
        keys = {
            {
                mode = { 'v', 'n' },
                '<Leader>m',
                '<cmd>MCstart<cr>',
                desc = 'Create a selection for selected text or word under the cursor',
            },
        },
    },
    { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" },
    { "nvim-lualine/lualine.nvim" },
    { "neovim/nvim-lspconfig", },
    { "williamboman/mason.nvim" },
    { 'hrsh7th/cmp-nvim-lsp' }, { 'hrsh7th/cmp-buffer' }, { 'hrsh7th/cmp-path' },
    { 'hrsh7th/cmp-cmdline' }, { 'xzbdmw/nvim-cmp' }, { 'saadparwaiz1/cmp_luasnip' },
    { 'lewis6991/gitsigns.nvim' },
    { "folke/trouble.nvim",     dependencies = { "nvim-tree/nvim-web-devicons" } },
    {
        "folke/which-key.nvim"
    },
    { "onsails/lspkind.nvim" },
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        lazy = false,
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        }
    },
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.5',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    { "jose-elias-alvarez/null-ls.nvim", enabled = false },
    { 'windwp/nvim-autopairs',           event = 'InsertEnter' },
    {
        'nvimdev/dashboard-nvim',
        event = 'VimEnter',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
    },
    { 'numToStr/Comment.nvim',         lazy = false },
    {
        'akinsho/bufferline.nvim',
        version = "*",
        dependencies = 'nvim-tree/nvim-web-devicons'
    },
    { 'ziontee113/icon-picker.nvim',   enabled = true },
    { 'stevearc/dressing.nvim' },
    { 'wakatime/vim-wakatime',         lazy = false },
    { "Shatur/neovim-session-manager", dependencies = "nvim-lua/plenary.nvim" },
    { "MaximilianLloyd/ascii.nvim",    dependencies = "MunifTanjim/nui.nvim" },
    { 'goolord/alpha-nvim',            dependencies = { 'nvim-tree/nvim-web-devicons' }, enabled = false },
    {
        'mrcjkb/rustaceanvim',
        version = '^4',
        ft = { 'rust' },
        enabled = true,
    },
    {
        "simrat39/rust-tools.nvim",
        dependencies = { "liuchengxu/graphviz.vim" },
        enabled = false,
    },
    {
        "L3MON4D3/LuaSnip",
        dependencies = {
            "rafamadriz/friendly-snippets",
        },
        version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        build = "make install_jsregexp",
    },
    { "nat-418/boole.nvim" },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    { "norcalli/nvim-colorizer.lua" },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        enabled = false
    },
    { "numToStr/FTerm.nvim" },
    { "mfussenegger/nvim-dap" },
    { "folke/neodev.nvim" },
    { "rcarriga/nvim-dap-ui" },
    { "johmsalas/text-case.nvim" },
    { "jonatan-branting/nvim-better-n" },
    { "ray-x/lsp_signature.nvim" },
    { "windwp/nvim-ts-autotag" },
    { "hedyhli/outline.nvim" },
    { "j-hui/fidget.nvim", },
    { "RRethy/vim-illuminate" },
    { "nvim-treesitter/nvim-treesitter-textobjects" },
    { "stevearc/oil.nvim" },
    { "nvim-neotest/nvim-nio" },
    { "mfussenegger/nvim-dap-python" },
    { "gbprod/substitute.nvim" },
    { "stevearc/conform.nvim" },
    {
        "xiyaowong/transparent.nvim",
        lazy = false,
        enabled = false
    },
    {
        "Vimjas/vim-python-pep8-indent",
        enabled = false
    },
    {
        "mhartington/formatter.nvim",
        enabled = false
    },
    {
        "habamax/vim-godot",
        event = "BufEnter *.gd",
        lazy = false
    },
    {
        "rcarriga/nvim-notify",
        enabled = false
    },
    {
        "mrded/nvim-lsp-notify",
        config = function()
            require("lsp-notify").setup {
                notify = require('notify')
            }
        end,
        enabled = false
    },
    {
        "edluffy/hologram.nvim",
        enabled = false
    },
    {
        "linrongbin16/lsp-progress.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" }
    }
    -- {
    --     "yorik1984/lualine-xkblayout",
    --     dependencies =  {
    --         "nvim-lualine/lualine.nvim",
    --         "lyokha/vim-xkbswitch",
    --     },
    -- },
})
