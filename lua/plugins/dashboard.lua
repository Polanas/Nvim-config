function DefaultHeader()
    local header = require("ascii").art.text.neovim.sharp
    return header
end

require('dashboard').setup {
    theme = 'doom',
    config = {
        header = DefaultHeader(),
        center = {
        {
            icon = '󰙅 ',
            icon_hl = "Title",
            desc = 'Open tree',
            desc_hl = 'String',
            key = 'e',
            keymap = 'SPC e',
            key_hl = 'Number',
            action = ':NvimTreeOpen'
        }, {
            icon = '󰈞 ',
            icon_hl = 'Title',
            desc = 'Find files',
            desc_hl = 'String',
            key = 'f',
            keymap = 'SPC f f',
            key_hl = 'Number',
            action = ':Telescope find_files'
        }, {
            icon = ' ',
            icon_hl = 'Title',
            desc = 'Find text',
            desc_hl = 'String',
            key = 'w',
            keymap = 'SPC f w',
            key_hl = 'Number',
            action = ':Telescope live_grep'
        }, {
            icon = '▶ ',
            icon_hl = 'Title',
            desc = 'Open config',
            desc_hl = 'String',
            key = 'c',
            keymap = 'F7',
            key_hl = 'Number',
            action =
            function()
                vim.cmd("cd ~/.config/nvim/")
                vim.cmd("SessionManager load_current_dir_session")
            end
        }, {
            icon = ' ',
            icon_hl = 'Title',
            desc = 'Open session menu',
            desc_hl = 'String',
            key = 's',
            keymap = 'SPC s s',
            key_hl = 'Number',
            action = ':SessionManager load_session'
        }, {
            icon = ' ',
            icon_hl = 'Title',
            desc = 'Open last session',
            desc_hl = 'String',
            key = 'l',
            keymap = 'SPC s l',
            key_hl = 'Number',
            action = ':SessionManager load_last_session'
        }, {
            icon = ' ',
            icon_hl = 'Title',
            desc = 'Close vim',
            desc_hl = 'String',
            key = 'q',
            keymap = 'SPC w w',
            key_hl = 'Number',
            action = ':q' }
        }
    }
}
