local function can_save(bufnr)
    local is_modifiable = vim.fn.getbufvar(bufnr, "&modifiable") == 1
    local is_readonly = vim.fn.getbufvar(bufnr, "&readonly") == 1
    local buftype = vim.api.nvim_get_option_value("buftype", {})
    local is_modified = vim.api.nvim_get_option_value("modified", {})
    local is_named = vim.fn.bufname() ~= ""

    return is_modifiable
        and not is_readonly
        and buftype == ""
        and is_modified
        and is_named
end

-- auto save
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
    callback = function(args)
        if can_save(args.buf or vim.api.nvim_get_current_buf()) then
            vim.fn.timer_start(100, function()
                vim.cmd(":silent w")
            end)
        end
    end
})

--makes statusline global
vim.api.nvim_create_autocmd({ "BufEnter" }, {
    callback = function()
        vim.opt.laststatus = 3
    end
})

function LEAVE_SNIPPET()
    if
        ((vim.v.event.old_mode == 's' and vim.v.event.new_mode == 'n') or vim.v.event.old_mode == 'i')
        and require('luasnip').session.current_nodes[vim.api.nvim_get_current_buf()]
        and not require('luasnip').session.jump_active
    then
        require('luasnip').unlink_current()
    end
end
-- stop snippets when you leave to normal mode
vim.api.nvim_command([[
    autocmd ModeChanged * lua LEAVE_SNIPPET()
    ]])

-- load folds on enerting buffer
-- vim.api.nvim_create_autocmd("BufWinEnter", {
--     pattern = { "*.*" },
--     desc = "Save folds",
--     command = "silent! loadview",
-- })
