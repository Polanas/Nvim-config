TransparencyToggleState = false
vim.api.nvim_create_user_command("ToggleTransparency",
    function()
        TransparencyToggleState = not TransparencyToggleState
        if TransparencyToggleState then
            vim.g.neovide_transparency = 0
        else
            vim.g.neovide_transparency = 1
        end
    end, {})
vim.api.nvim_create_user_command("FontSize",
    function()
        print("Current font size: " .. CurrentGuiFontSize)
    end, {})

vim.api.nvim_create_user_command("BufEnter", function()
    --makes statusline global
    vim.opt.laststatus = 3
    print("hi")
end, {})
