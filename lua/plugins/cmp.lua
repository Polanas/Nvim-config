local ELLIPSIS_CHAR = '…'
local MAX_LABEL_WIDTH = 40

local get_ws = function(max, len)
    return (" "):rep(max - len)
end

local format = function(_, item)
    local content = item.abbr
    -- local kind_symbol = symbols[item.kind]
    -- item.kind = kind_symbol .. get_ws(MAX_KIND_WIDTH, #kind_symbol)

    if #content > MAX_LABEL_WIDTH then
        item.abbr = vim.fn.strcharpart(content, 0, MAX_LABEL_WIDTH) .. ELLIPSIS_CHAR
    else
        item.abbr = content .. get_ws(MAX_LABEL_WIDTH, #content)
    end

    return item
end


local function findLast(haystack, needle)
    local i = haystack:match(".*" .. needle .. "()")
    if i == nil then
        return nil
    else
        return i - 1
    end
end

--[[ local function trim_detail(detail)
    if detail then
        detail = vim.trim(detail)
        if vim.startswith(detail, "(use") then
            detail = string.sub(detail, 6, #detail)
        end
        local last = findLast(detail, "%:")
        if last then
            local last_item = detail:sub(last + 1, #detail - 1)
            detail = detail:sub(1, last - 2)
            detail = last_item .. " " .. detail
            detail = "(" .. detail .. ")"
        else
            detail = "(" .. detail
        end
    end
    return detail
end ]]
local function trim_detail(detail)
    if detail then
        detail = vim.trim(detail)
        if vim.startswith(detail, "(use") then
            detail = string.sub(detail, 6, #detail)
            detail = "(" .. detail
        end
    end
    return detail
end

local function match_fn(description)
    return string.match(description, "^pub fn")
        or string.match(description, "^pub async fn")
        or string.match(description, "^fn")
        or string.match(description, "^async fn")
        or string.match(description, "^unsafe fn")
        or string.match(description, "^unsafe async fn")
        or string.match(description, "^pub unsafe fn")
        or string.match(description, "^pub unsafe async fn")
        or string.match(description, "^pub const unsafe fn")
        or string.match(description, "^const fn")
        or string.match(description, "^pub const fn")
end

local function rust_fmt(entry, vim_item)
    local kind = require("lspkind").cmp_format({
        mode = "symbol_text",
    })(entry, vim_item)
    local strings = vim.split(kind.kind, "%s", { trimempty = true })
    local completion_item = entry:get_completion_item()
    local item_kind = entry:get_kind() --- @type lsp.CompletionItemKind | number

    local label_detail = completion_item.labelDetails
    if item_kind == 3 or item_kind == 2 then -- Function/Method
        --[[ labelDetails.
        function#function#if detail: {
          description = "pub fn shl(self, rhs: Rhs) -> Self::Output",
          detail = " (use std::ops::Shl)"
        } ]]
        if label_detail then
            local detail = label_detail.detail
            detail = trim_detail(detail)
            local description = label_detail.description
            if description then
                if string.sub(description, #description, #description) == "," then
                    description = description:sub(1, #description - 1)
                end
            end
            if
                (detail and vim.startswith(detail, "macro")) or (description and vim.startswith(description, "macro"))
            then
                kind.concat = kind.abbr
                goto OUT
            end
            if detail and description then
                if match_fn(description) then
                    local start_index, _ = string.find(description, "(", nil, true)
                    if start_index then
                        description = description:sub(start_index, #description)
                    end
                end
                local index = string.find(kind.abbr, "(", nil, true)
                -- description: "macro simd_swizzle"
                -- detail: " (use std::simd::simd_swizzle)"
                if index then
                    local prefix = string.sub(kind.abbr, 1, index - 1)
                    kind.abbr = prefix .. description .. " " .. detail
                    kind.concat = "fn " .. prefix .. description .. "{}//" .. detail
                    kind.offset = 3
                else
                    kind.concat = kind.abbr .. "  //" .. detail
                    kind.abbr = kind.abbr .. " " .. detail
                end
            elseif detail then
                kind.concat = "fn " .. kind.abbr .. "{}//" .. detail
                kind.abbr = kind.abbr .. " " .. detail
            elseif description then
                if match_fn(description) then
                    local start_index, _ = string.find(description, "%(")
                    if start_index then
                        description = description:sub(start_index, #description)
                    end
                end
                local index = string.find(kind.abbr, "(", nil, true)
                if index then
                    local prefix = string.sub(kind.abbr, 1, index - 1)
                    kind.abbr = prefix .. description .. " "
                    kind.concat = "fn " .. prefix .. description .. "{}//"
                    kind.offset = 3
                else
                    kind.concat = kind.abbr .. "  //" .. description
                    kind.abbr = kind.abbr .. " " .. description
                end
            else
                kind.concat = kind.abbr
            end
        end
    elseif item_kind == 15 then
    elseif item_kind == 5 then -- Field
        local detail = completion_item.detail
        detail = trim_detail(detail)
        if detail then
            kind.concat = "struct S {" .. kind.abbr .. ": " .. detail .. "}"
            kind.abbr = kind.abbr .. ": " .. detail
        else
            kind.concat = "struct S {" .. kind.abbr .. ": String" .. "}"
        end
        kind.offset = 10
    elseif item_kind == 6 or item_kind == 21 then -- variable constant
        if label_detail then
            local detail = label_detail.description
            if detail then
                kind.concat = "let " .. kind.abbr .. ": " .. detail
                kind.abbr = kind.abbr .. ": " .. detail
                kind.offset = 4
            else
                kind.concat = kind.abbr
            end
        end
    elseif item_kind == 9 then -- Module
        local detail = label_detail.detail
        detail = trim_detail(detail)
        if detail then
            kind.concat = kind.abbr .. "  //" .. detail
            kind.abbr = kind.abbr .. " " .. detail
            kind.offset = 0
        else
            kind.concat = kind.abbr
        end
    elseif item_kind == 8 then -- Trait
        local detail = label_detail.detail
        detail = trim_detail(detail)
        if detail then
            kind.concat = "trait " .. kind.abbr .. "{}//" .. detail
            kind.abbr = kind.abbr .. " " .. detail
        else
            kind.concat = "trait " .. kind.abbr .. "{}"
            kind.abbr = kind.abbr
        end
        kind.offset = 6
    elseif item_kind == 22 then -- Struct
        local detail = label_detail.detail
        detail = trim_detail(detail)
        if detail then
            kind.concat = kind.abbr .. "  //" .. detail
            kind.abbr = kind.abbr .. " " .. detail
        else
            kind.concat = kind.abbr
        end
    elseif item_kind == 1 then -- "Text"
        kind.concat = '"' .. kind.abbr .. '"'
        kind.offset = 1
    elseif item_kind == 14 then
        if kind.abbr == "mut" then
            kind.concat = "let mut"
            kind.offset = 4
        else
            kind.concat = kind.abbr
        end
    else
        -- if label_detail then
        --     local detail = label_detail.detail
        --     local description = label_detail.description
        --     if detail then
        --         kind.abbr = kind.abbr .. " " .. detail
        --     end
        --     if description then
        --         kind.abbr = kind.abbr .. " " .. description
        --     end
        -- end
        -- if completion_item.detail then
        --     kind.abbr = kind.abbr .. " " .. completion_item.detail
        -- end
        kind.concat = kind.abbr
    end
    if item_kind == 15 then
        kind.concat = ""
    end
    ::OUT::
    kind.kind = " " .. (strings[1] or "") .. " "
    kind.menu = nil
    if string.len(kind.abbr) > 60 then
        kind.abbr = kind.abbr:sub(1, 60)
    end
    return kind
end

local function lua_fmt(entry, vim_item)
    local kind = require("lspkind").cmp_format({
        mode = "symbol_text",
    })(entry, vim_item)
    local strings = vim.split(kind.kind, "%s", { trimempty = true })
    local item_kind = entry:get_kind() --- @type lsp.CompletionItemKind | number
    if item_kind == 5 then             -- Field
        kind.concat = "v." .. kind.abbr
        kind.offset = 2
    elseif item_kind == 1 then -- Text
        kind.concat = '"' .. kind.abbr .. '"'
        kind.offset = 1
    else
        kind.concat = kind.abbr
    end
    kind.abbr = kind.abbr
    kind.kind = " " .. (strings[1] or "") .. " "
    kind.menu = nil
    if string.len(kind.abbr) > 50 then
        kind.abbr = kind.abbr:sub(1, 50)
    end
    return kind
end
local function go_fmt(entry, vim_item)
    local kind = require("lspkind").cmp_format({
        mode = "symbol_text",
    })(entry, vim_item)
    local strings = vim.split(kind.kind, "%s", { trimempty = true })
    local item_kind = entry:get_kind() --- @type lsp.CompletionItemKind | number
    local completion_item = entry:get_completion_item()

    local detail = completion_item.detail
    if item_kind == 5 then -- Field
        if detail then
            local last = findLast(kind.abbr, "%.")
            if last then
                local catstr = kind.abbr:sub(last + 1, #kind.abbr)
                local space_hole = string.rep(" ", last)
                kind.concat = "type T struct{" .. space_hole .. catstr .. " " .. detail .. "}"
                kind.offset = 14
                kind.abbr = kind.abbr .. " " .. detail
            else
                kind.concat = "type T struct{" .. kind.abbr .. " " .. detail .. "}"
                kind.offset = 14
                kind.abbr = kind.abbr .. " " .. detail
            end
        else
            kind.concat = "type T struct{" .. kind.abbr .. " " .. "}"
            kind.offset = 14
            kind.abbr = kind.abbr .. " " .. detail
        end
    elseif item_kind == 1 then -- Text
        kind.concat = '"' .. kind.abbr .. '"'
        kind.offset = 1
    elseif item_kind == 6 or item_kind == 21 then -- Variable
        local last = findLast(kind.abbr, "%.")
        if detail then
            if last then
                local catstr = kind.abbr:sub(last + 1, #kind.abbr)
                local space_hole = string.rep(" ", last)
                kind.concat = "var " .. space_hole .. catstr .. " " .. detail
                kind.offset = 4
                kind.abbr = kind.abbr .. " " .. detail
            else
                if detail then
                    kind.concat = "var " .. kind.abbr .. " " .. detail
                    kind.abbr = kind.abbr .. " " .. detail
                    kind.offset = 4
                end
            end
        end
    elseif item_kind == 22 then -- Struct
        local last = findLast(kind.abbr, "%.")
        if last then
            local catstr = kind.abbr:sub(last + 1, #kind.abbr)
            local space_hole = string.rep(" ", last)
            kind.concat = "type " .. space_hole .. catstr .. " struct{}"
            kind.offset = 5
            kind.abbr = kind.abbr .. " struct{}"
        else
            kind.concat = "type " .. kind.abbr .. " struct{}"
            kind.abbr = kind.abbr .. " struct{}"
            kind.offset = 5
        end
    elseif item_kind == 3 or item_kind == 2 then -- Function/Method
        local last = findLast(kind.abbr, "%.")
        if last then
            if detail then
                detail = detail:sub(5, #detail)
                kind.abbr = kind.abbr .. detail
                local catstr = kind.abbr:sub(last + 1, #kind.abbr)
                local space_hole = string.rep(" ", last)
                kind.concat = "func " .. space_hole .. catstr .. "{}"
                kind.offset = 5
            else
                kind.concat = "func " .. kind.abbr .. "(){}"
                kind.offset = 5
            end
        else
            if detail then
                detail = detail:sub(5, #detail)
                kind.abbr = kind.abbr .. detail
                kind.concat = "func " .. kind.abbr .. "{}"
                kind.offset = 5
            else
                kind.concat = "func " .. kind.abbr .. "(){}"
                kind.abbr = kind.abbr
                kind.offset = 5
            end
        end
    elseif item_kind == 9 then -- Module
        if detail then
            kind.offset = 6 - #kind.abbr
            kind.abbr = kind.abbr .. " " .. detail
            kind.concat = "import " .. detail
        end
    elseif item_kind == 8 then -- Interface
        local last = findLast(kind.abbr, "%.")
        if last then
            local catstr = kind.abbr:sub(last + 1, #kind.abbr)
            local space_hole = string.rep(" ", last)
            kind.concat = "type " .. space_hole .. catstr .. " interface{}"
            kind.offset = 5
            kind.abbr = kind.abbr .. " interface{}"
        else
            kind.concat = "type " .. kind.abbr .. " interface{}"
            kind.abbr = kind.abbr .. " interface{}"
            kind.offset = 5
        end
    else
        kind.concat = kind.abbr
    end
    kind.kind = " " .. (strings[1] or "") .. " "
    kind.menu = ""
    if string.len(kind.abbr) > 50 then
        kind.abbr = kind.abbr:sub(1, 50)
    end
    return kind
end

local format_colorful = function(entry, vim_item)
    local function commom_format(e, item)
        local kind = require("lspkind").cmp_format({
            mode = "symbol_text",
            -- show_labelDetails = true, -- show labelDetails in menu. Disabled by default
        })(e, item)
        local strings = vim.split(kind.kind, "%s", { trimempty = true })
        kind.kind = " " .. (strings[1] or "") .. " "
        kind.menu = ""
        kind.concat = kind.abbr
        return kind
    end
    local get_mode = function()
        local mode = vim.api.nvim_get_mode().mode:sub(1, 1)
        if mode == "i" then
            return "i" -- insert
        elseif mode == "v" or mode == "V" or mode == CTRL_V then
            return "x" -- visual
        elseif mode == "s" or mode == "S" or mode == CTRL_S then
            return "s" -- select
        elseif mode == "c" and vim.fn.getcmdtype() ~= "=" then
            return "c" -- cmdline
        end
    end
    -- if get_mode() == "c" then
    --     return commom_format(entry, vim_item)
    -- end
    if vim.bo.filetype == "rust" then
        return rust_fmt(entry, vim_item)
    elseif vim.bo.filetype == "lua" then
        return lua_fmt(entry, vim_item)
    elseif vim.bo.filetype == "go" then
        return go_fmt(entry, vim_item)
    else
        return commom_format(entry, vim_item)
    end
end

local put_down_snippet = function(entry1, entry2)
    local types = require("cmp.types")
    local kind1 = entry1:get_kind() --- @type lsp.CompletionItemKind | number
    local kind2 = entry2:get_kind() --- @type lsp.CompletionItemKind | number
    kind1 = kind1 == types.lsp.CompletionItemKind.Text and 100 or kind1
    kind2 = kind2 == types.lsp.CompletionItemKind.Text and 100 or kind2
    if kind1 ~= kind2 then
        if kind1 == types.lsp.CompletionItemKind.Snippet then
            return false
        end
        if kind2 == types.lsp.CompletionItemKind.Snippet then
            return true
        end
    end
    return nil
end
vim.cmd("set pumheight=10")
local cmp = require 'cmp'
-- function sort_innder(s1, s2)
--     if s1 == nil then
--         return false
--     end
--     local s = "Borrow"
--     if (s1:find(s) == nil) ~= (s2:find(s) == nil) then
--         return s1:find(s) == nil
--     end
--     return nil
-- end
--
-- local function my_sort(entry1, entry2)
--     local label1 = entry1.completion_item.detail
--     local label2 = entry2.completion_item.detail
--     return sort_innder(label1, label2)
-- end

cmp.setup({
    formatting = {
        fields = { "kind", "abbr", "menu" },
        format = format_colorful
    },
    -- sorting = {
    --     priority_weight = 1.0,
    --     comparators = {
    --         cmp.locality,
    --         cmp.recently_used,
    --         cmp.score, -- based on :  score = score + ((#sources - (source_index - 1)) * sorting.priority_weight)
    --         cmp.offset,
    --         cmp.order,
    --     },
    -- },
    view = {
        docs = {
            auto_open = false,
        }
    },
    performance = {
        debounce = 0,
        throttle = 0,
        fetching_timeout = 5,
        confirm_resolve_timeout = 80,
        -- async_budget = 1,
        max_view_entries = 20,
    },
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
            -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        end
    },
    window = {
        completion = {
            scrollbar = false
        },
        documentation = cmp.config.window.bordered()
    },
    mapping = cmp.mapping.preset.insert({
        -- ['<Tab>'] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' }, { name = 'luasnip' },
    }, { { name = 'buffer' }, { name = 'nvim_lsp_signature_help' } })
})
-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
        { name = 'cmp_git' } -- You can specify the `cmp_git` source if you were installed it.
    }, { { name = 'buffer' } })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = { { name = 'buffer' } }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({ { name = 'path' } }, { { name = 'cmdline' } })
})
-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- require('lspconfig')['lua_ls'].setup { capabilities = capabilities }
-- require('lspconfig')['wgsl_analyzer'].setup { capabilities = capabilities }
-- require('lspconfig')['html'].setup { capabilities = capabilities }
