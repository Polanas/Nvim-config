local opts = { silent = true, remap = false }

-- leader key
vim.keymap.set("n", "<Space>", "<Nop>", opts)
vim.keymap.set("v", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "

-- nvim tree
vim.keymap.set("n", "<leader>e",
    function()
        vim.cmd(":NvimTreeToggle")
    end, opts)
vim.keymap.set("n", "<leader>f",
    function()
        vim.cmd(":Telescope find_files")
    end, opts)
vim.keymap.set("n", "<C-b><C-b>", "<C-v>")

-- quit all
vim.keymap.set("n", "<leader>we",
    function()
        vim.cmd("qa!")
    end, opts)
-- adds <c-r> behaviour to terminal mode
vim.keymap.set('t', '<c-r>', function()
    local next_char_code = vim.fn.getchar()
    local next_char = vim.fn.nr2char(next_char_code)
    return '<C-\\><C-N>"' .. next_char .. 'pi'
end, { expr = true })


-- full-screen bind
if vim.g.neovide == true then
    vim.keymap.set("n", "<F11>", "<cmd>let g:neovide_fullscreen = !g:neovide_fullscreen<cr>", opts)
end

DapguiState = false
vim.keymap.set("n", "<leader>Dp",
    function()
        require('dapui').toggle();
        DapguiState = not DapguiState

        if DapguiState then
            print("dapui is opened")
        else
            print("dapui is closed")
        end
    end, opts);
vim.keymap.set("n", "<leader>de", "<cmd>:lua require'dapui'.eval()<cr>", opts);
vim.keymap.set("n", "<leader>ds",
    function()
        require('dapui').float_element("scopes")
    end, opts);

vim.keymap.set("n", "<leader>dS",
    function()
        require('dapui').float_element("stacks")
    end, opts);

-- fast semicolon
-- some keys can't be maped. Use <C-v> in insert mode to check if a mapping is valid.
-- TODO: figure out how to map this
-- vim.keymap.set("i", "<C-;>", "<C-o>A;")

-- font size control
function SetFontSize(font_size)
    vim.cmd("set guifont=" .. GuiFont .. tostring(font_size))
end

-- these are remaped to Ctrl + and Ctrl -
vim.keymap.set("n", "+", "<Nop>");
vim.keymap.set("n", "+",
    function()
        CurrentGuiFontSize = CurrentGuiFontSize + 1
        SetFontSize(CurrentGuiFontSize)
    end, opts)
vim.keymap.set("n", "-",
    function()
        if CurrentGuiFontSize < 10 then
            return
        end

        CurrentGuiFontSize = CurrentGuiFontSize - 1
        SetFontSize(CurrentGuiFontSize)
    end, opts)

-- opens outline menu
vim.keymap.set("n", "<leader>o", function()
    vim.cmd(":Outline")
end, opts)

local function fold_match(regex)
    vim.cmd("normal! mz");
    vim.cmd([[silent %g/]] .. regex .. [[/ normal! f(hza]])
    vim.cmd("normal! `z");
    vim.cmd("delmarks z")
end

--TODO: refactor all mappings
local mappings = {
    -- bufferline
    { "n",          "<leader>1",  '<cmd>:lua require("bufferline").go_to(1, true)<cr>',       opts },
    { "n",          "<leader>2",  '<cmd>:lua require("bufferline").go_to(2, true)<cr>',       opts },
    { "n",          "<leader>3",  '<cmd>:lua require("bufferline").go_to(3, true)<cr>',       opts },
    { "n",          "<leader>4",  '<cmd>:lua require("bufferline").go_to(4, true)<cr>',       opts },
    { "n",          "<leader>5",  '<cmd>:lua require("bufferline").go_to(5, true)<cr>',       opts },
    { "n",          "<leader>6",  '<cmd>:lua require("bufferline").go_to(6, true)<cr>',       opts },
    { "n",          "<leader>7",  '<cmd>:lua require("bufferline").go_to(7, true)<cr>',       opts },
    { "n",          "<leader>8",  '<cmd>:lua require("bufferline").go_to(8, true)<cr>',       opts },
    { "n",          "<leader>9",  '<cmd>:lua require("bufferline").go_to(9, true)<cr>',       opts },
    { "n",          "<leader>$",  '<cmd>:lua require("bufferline").go_to(-1, true)<cr>',      opts },
    { "n",          "<leader>bd", "<cmd>:bd<cr> <BAR> <cmd>:blast<cr>",                       opts },
    { "n",          "<leader>co", "<cmd>:BufferLineCloseOthers<cr>",                          opts },
    { "n",          "<leader>bs", "<cmd>:BufferLinePick<cr>",                                 opts },
    { "n",          "<leader>bc", "<cmd>:BufferLinePickClose<cr>",                            opts },
    { "n",          "<leader>bl", "<cmd>:BufferLineCloseLeft<cr>",                            opts },
    { "n",          "<leader>br", "<cmd>:BufferLineCloseRight<cr>",                           opts },
    { "n",          "<Left>",     "<cmd>:BufferLineCyclePrev<cr>",                            opts },
    { "n",          "<Right>",    "<cmd>:BufferLineCycleNext<cr>",                            opts },
    -- sessions
    { "n",          "<leader>ss", "<cmd>:SessionManager load_session<cr>",                    opts },
    { "n",          "<leader>sd", "<cmd>:SessionManager delete_session<cr>",                  opts },
    { "n",          "<leader>sl", "<cmd>:SessionManager load_last_session<cr>",               opts },
    -- buffers navigation
    { "n",          "<leader>k",  "<C-W>k",                                                   opts },
    { "n",          "<leader>j",  "<C-W>j",                                                   opts },
    { "n",          "<leader>h",  "<C-W>h",                                                   opts },
    { "n",          "<leader>l",  "<C-W>l",                                                   opts },
    -- it just makes more sense
    { "n",          "<C-W>h",     "<C-W>s",                                                   opts },
    -- ctrl+backspace to delete a word
    { "i",          "<C-H>",      "<C-W>",                                                    opts },
    -- moving lines
    -- { "n",          "<A-j>",      MoveLineOrItemDown,                                    snoremap },
    -- { "n",          "<A-k>",      MoveLineOrItemUp,                                      snoremap },
    -- quit
    { "n",          "<C-q>",      "<cmd>:q<cr>",                                              opts },
    -- open diagnostics
    { "n",          "<leader>dd", "<cmd>:lua vim.diagnostic.open_float()<cr>",                opts },
    -- trouble
    { "n",          "<leader>T",  "<cmd>:Trouble diagnostics toggle<cr><C-W>j",               opts },
    -- ctrl-c + ctrl-v
    -- TODO: refactor copy/paste
    -- vim.keymap.set("n", "<leader>c", '"+y', opts)
    { "n",          "<leader>v",  'o<Esc>"+p',                                                opts },
    { "n",          "<leader>V",  'O<Esc>"+p',                                                opts },
    { "i",          "<C-v>",      '<c-r>+',                                                   opts },
    { "t",          "<C-v>",      '<c-r>+',                                                   opts },
    -- show todo list
    { 'n',          '<leader>ft', '<cmd>:TodoTelescope<cr>',                                  opts },
    { 'n',          '<leader>tt', '<cmd>Telescope resume<cr>',                                opts },
    { 'n',          '<leader>tr', '<cmd>silent! Neotest run<cr>',                             opts },
    { 'n',          '<leader>tR', '<cmd>lua require("neotest").run.run(vim.fn.getcwd())<cr>', opts },
    { 'n',          '<leader>to', '<cmd>Neotest summary<cr>',                                 opts },
    -- debugging
    { "n",          "<leader>B",  "<cmd>:lua require'dap'.toggle_breakpoint()<cr>",           opts },
    { "n",          "<F5>",       "<cmd>:lua require'dap'.continue()<cr>",                    opts },
    { "n",          "<F7>",       "<cmd>:lua require'dap'.step_over()<cr>",                   opts },
    { "n",          "<F8>",       "<cmd>:lua require'dap'.step_into()<cr>",                   opts },
    { "n",          "<leader>dq", "<cmd>:lua require'dap'.disconnect({})<cr>",                opts },
    { "n",          "<leader>dr", "<cmd>:RustDebuggables<cr>",                                opts },
    -- faster movement
    { { "n", "v" }, "J",          "<Nop>",                                                    opts },
    { { "n", "v" }, "J",          "5j",                                                       opts },
    { { "n", "v" }, "K",          "<Nop>",                                                    opts },
    { { "n", "v" }, "K",          "5k",                                                       opts },
    -- moving blocks of text around
    { 'n',          '<A-j>',      ':MoveLine(1)<CR>',                                         opts },
    { 'n',          '<A-k>',      ':MoveLine(-1)<CR>',                                        opts },
    { 'v',          '<A-j>',      ':MoveBlock(1)<CR>',                                        opts },
    { 'v',          '<A-k>',      ':MoveBlock(-1)<CR>',                                       opts },
    -- bind J functionality to ctrl + j
    { "n",          "<C-j>",      "J",                                                        opts },
    { "n", "<leader>ia", function()
        local api = require("nvim-tree.api")
        local node = api.tree.get_node_under_cursor()
        if node == nil then
            return
        end
        vim.fn.jobstart(AsepritePath .. " " .. node.absolute_path)
    end },
    { "n", "<leader>in", function()
        local api = require("nvim-tree.api")
        local node = api.tree.get_node_under_cursor()
        if node == nil then
            return
        end
        vim.fn.jobstart("nautilus --browser " .. node.absolute_path)
    end },
    { "n", "<leader>rr", "<cmd>luafile %<cr>", },
    { "n", "<leader>bp", "<cmd>bp<cr>", },
    { "n", "<leader>bn", "<cmd>bn<cr>", },
    { "n", "<leader>dk", "<cmd>ToggleCommentDebugPrints<cr>" },
    { "n", "<leader>dl", "<cmd>DeleteDebugPrints<cr>" },
    -- build a rust crate silently
    { "n", "<leader>cb", "<cmd>silent !cargo build<cr>",     opts },
    { "n", "<leader>O",  "<cmd>Oil . <cr>",                  opts },
    { "n", "ze",
        --TODO: add this only in rust files
        function()
            fold_match("")
            vim.cmd("mkview")
        end
    },
    -- the following two mappings extend defaults zM and zR
    -- TODO: add API to extend default mappings
    { "n", "zM", "<Nop>" },
    { "n", "zM", function()
        vim.cmd("normal! zM")
        vim.cmd("mkview")
    end },
    { "n", "zR", "<Nop>" },
    { "n", "zR", function()
        vim.cmd("normal! zR")
        vim.cmd("mkview")
    end },
    { "n", "zf",
        --TODO: add this only in rust files
        function()
            fold_match([[fn \w*]])
            vim.cmd("mkview")
        end
    },
    -- ^ *\(pub \)\?fn'
    { "i", "<A-h>", function()
        local ls = require("luasnip")
        if ls.choice_active() then
            ls.change_choice(-1)
        end
    end },
    { "i", "<A-l>", function()
        local ls = require("luasnip")
        if ls.choice_active() then
            print("moved left")
            ls.change_choice(1)
        end
    end },
    { "n", "<Tab>", function()
        local cmp = require("cmp")
        if not cmp.visible() then
            vim.cmd("silent normal za")
        end
    end },
    {
        "i",
        "<Tab>",
        function()
            local ls = require("luasnip")
            local cmp = require("cmp")
            if TAB_STATE == TAB_IN_SNIPPET and CURRENT_JUMPS_AMOUNT == TOTAL_JUMPS_AMOUNT - 1 then
                ls.unlink_current()
                TAB_STATE = TAB_NOT_IN_SNIPPET
            end
            if cmp.visible() then
                cmp.confirm({ select = true })
                -- if there's only two jumps, we need to unlink the snippet immediately
                vim.fn.timer_start(20, function()
                    if ls.get_active_snip() == nil then
                        return
                    end
                    local inset_nodes = ls.get_active_snip().insert_nodes
                    local amount = 0
                    for _, _ in pairs(inset_nodes) do
                        amount = amount + 1
                    end
                    if amount == 2 then
                        ls.unlink_current()
                        TAB_STATE = TAB_NOT_IN_SNIPPET
                    end
                end)
            elseif ls.expand_or_jumpable() then
                if TAB_STATE == TAB_NOT_IN_SNIPPET then
                    CURRENT_JUMPS_AMOUNT = 0
                    local inset_nodes = ls.get_active_snip().insert_nodes
                    local amount = 0
                    for _, _ in pairs(inset_nodes) do
                        amount = amount + 1
                    end
                    TOTAL_JUMPS_AMOUNT = amount - 1
                end
                TAB_STATE = TAB_IN_SNIPPET
                ls.expand_or_jump()
                CURRENT_JUMPS_AMOUNT = CURRENT_JUMPS_AMOUNT + 1
            else
                TAB_STATE = TAB_NOT_IN_SNIPPET
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
            end
        end,
        init_func = function()
            TAB_IN_SNIPPET = 0
            TAB_NOT_IN_SNIPPET = 1
            TAB_STATE = TAB_NOT_IN_SNIPPET
            CURRENT_JUMPS_AMOUNT = 0
            TOTAL_JUMPS_AMOUNT = 1
        end,
        enabled = true,
    }
}

local function del_mappings()
    if OLD_MAPINGS == nil then
        return
    end
    for _, v in pairs(OLD_MAPINGS) do
        pcall(vim.keymap.del, v[1], v[2])
    end
end
local function set_mappings()
    del_mappings()
    for _, v in pairs(mappings) do
        if v.init_func ~= nil then
            v.init_func()
        end
        if not (v.enable ~= nil and not v.enable) then
            vim.keymap.set(v[1], v[2], v[3], v[4])
        end
    end
end
set_mappings()

OLD_MAPINGS = mappings
