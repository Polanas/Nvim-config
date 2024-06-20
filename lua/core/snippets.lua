local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local extras = require("luasnip.extras")
local rep = extras.rep
local fmt = require("luasnip.extras.fmt").fmt
local c = ls.choice_node
local f = ls.function_node
ls.cleanup()

local function add_rust_snippets()
    ls.add_snippets("rust", {
        s("tstbl", {
            t({ '#[cfg(test)]', 'mod tests {', '\tuse super::*;', '', '\t#[test]' }),
            t({ '', '\tfn ' }),
            i(1, 'test_name'),
            t({ '() {', '\t\t', }),
            i(2),
            t({ '', '\t}', '}' })
        }),
    })
end
local function insert_option()
    local ls = require("luasnip")
    ls.unlink_current()
    vim.fn.timer_start(50, function()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-o>daW", true, false, true), "i", false)
    end)
end
local function add_lua_snippets()
    ls.add_snippets("lua", {
        s("choice", fmt([[{}]], { c(1, { t("one"), t("two") }) })),
        s(".some", f(insert_option)),
    })
end
---@return table
---@diagnostic disable-next-line: unused-local
local function current_date()
    ---@diagnostic disable-next-line: return-type-mismatch
    return os.date("*t", os.time())
end
-- welll idk 2
add_lua_snippets()
add_rust_snippets()
ls.setup {
    update_events = { "TextChanged", "TextChangedI" }
}
-- require("luasnip.loaders.from_vscode").lazy_load()
