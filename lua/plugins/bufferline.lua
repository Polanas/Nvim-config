require("bufferline").setup {
    options = {
        buffer_close_icon     = '',
        mode                  = 'buffers',
        numbers               = "none",
        offsets               = {
            {
                filetype = "NvimTree",
                text = "File Explorer",
                separator = true,
                padding = 1
            }
        },
        diagnostics           = "nvim_lsp",
        groups                = {
            items = {
                require("bufferline.groups").builtin.pinned:with({ icon = "" })
            }
        },
        indicator             = {
            icon = '  ', -- this should be omitted if indicator style is not 'icon'
            style = 'icon'
        },
        -- diagnostics_indicator = function(count, level, diagnostics_dict, context)
        --     local s = ""
        --     for e, n in pairs(diagnostics_dict) do
        --         local sym = e == "error" and " "
        --             or (e == "warning" and " " or " " or " ")
        --         s = s .. n .. sym
        --     end
        --     return s
        -- end,
        -- custom_areas          = {
        --     right = function()
        --         local result = {}
        --         local seve = vim.diagnostic.severity
        --         local error = #vim.diagnostic.get(0, { severity = seve.ERROR })
        --         local warning = #vim.diagnostic.get(0, { severity = seve.WARN })
        --         local info = #vim.diagnostic.get(0, { severity = seve.INFO })
        --         local hint = #vim.diagnostic.get(0, { severity = seve.HINT })
        --
        --         if error ~= 0 then
        --             table.insert(result, { text = "  " .. error, fg = "#EC5241" })
        --         end
        --
        --         if warning ~= 0 then
        --             table.insert(result, { text = "  " .. warning, fg = "#EFB839" })
        --         end
        --
        --         if hint ~= 0 then
        --             table.insert(result, { text = "  " .. hint, fg = "#A3BA5E" })
        --         end
        --
        --         if info ~= 0 then
        --             table.insert(result, { text = "  " .. info, fg = "#7EA9A7" })
        --         end
        --         return result
        --     end, } 
    }
}
