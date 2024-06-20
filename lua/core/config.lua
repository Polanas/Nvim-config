-- vim.opt.mouse = ""

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.netrw_nogx = 1
vim.cmd("nmap gx <Plug>(openbrowser-open)")

vim.o.number = true
vim.o.relativenumber = true

vim.g.did_load_filetypes = 1
vim.g.formatoptions = "qrn1"
vim.opt.showmode = false
vim.opt.updatetime = 100
vim.wo.signcolumn = "yes"
vim.opt.scrolloff = 8
vim.opt.wrap = true
vim.wo.linebreak = true
vim.opt.virtualedit = "block"
vim.opt.undofile = true

-- Line Numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Splits
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Clipboard
--vim.opt.clipboard = "unnamedplus"

-- Shorter messages
vim.opt.shortmess:append("c")

-- Indent Settings
vim.opt.expandtab = true
vim.opt.cpoptions = "I"
vim.opt.autoindent = true
vim.opt.shiftwidth = 0
vim.opt.tabstop = 4
vim.opt.softtabstop = -1
vim.opt.smartindent = true
vim.opt.shiftround = true
vim.cmd("filetype plugin indent on")

-- Fillchars
vim.opt.fillchars = {
    vert = "│",
    fold = "⠀",
    eob = " ", -- suppress ~ at EndOfBuffer
    -- diff = "⣿", -- alternatives = ⣿ ░ ─ ╱
    msgsep = "‾",
    foldopen = "▾",
    foldsep = "│",
    foldclose = "▸"
}
-- wrap long lines
vim.o.wrap = true
-- wrap between lines
-- vim.cmd("set whichwrap+=<,>,h,l,[,]")
-- vim.cmd("set whichwrap+=<,>,h,l")
-- set font
vim.cmd("set guifont=" .. GuiFont .. "16")
-- cd to documents
vim.cmd("cd ~/Documents")

-- enable xkb switch
-- vim.g.XkbSwitchEnabled = 1
-- vim.cmd("let g:XkbSwitchEnabled = 1")
-- vim.cmd("let g:XkbSwitchIMappings = ['ru']")
-- display number on the same row
vim.opt.numberwidth = 1

--highlight column number
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"
vim.o.foldmethod = "expr"
vim.o.foldexpr = "nvim_treesitter#foldexpr()"
vim.o.foldnestmax = 4
vim.o.foldcolumn = "0"
vim.o.foldtext = ""
vim.o.foldlevel = 99

-- error messages dont disappear in insert mode
vim.diagnostic.config({ update_in_insert = true })

-- set sonicboom vfx mode
if vim.g.neovide then
    vim.g.neovide_cursor_vfx_mode = "sonicboom"
    vim.g.neovide_remember_window_size = true
    vim.g.neovide_refresh_rate = 75*2
    vim.g.neovide_refresh_rate_idle = 75*2
    vim.g.neovide_no_idle = true
end
-- set godot path
-- TODO: remember to change that if needed
vim.g.godot_executable = '/home/palas/Documents/Godot/godot.x86_64'
-- this should fix swap files sometimes not being deleted
-- vim.cmd("set nohidden")
vim.cmd("set nofoldenable")

SetFontSize(CurrentGuiFontSize)
