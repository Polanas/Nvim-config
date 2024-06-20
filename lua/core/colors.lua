vim.opt.termguicolors = true
function SetColor(color)
    color = color
    vim.cmd.colorscheme(color)
    vim.api.nvim_set_hl(0, "ColorColumn", { bg = "none" })
    vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })
end

require("catppuccin").setup {
    flavour = "mocha", -- latte, frappe, macchiato, mocha
    no_italic = true,
    color_overrides = {
        mocha = {
            rosewater = "#efc9c2",
            flamingo = "#ebb2b2",
            pink = "#f2a7de",
            mauve = "#b889f4",
            red = "#ea7183",
            maroon = "#ea838c",
            peach = "#f39967",
            yellow = "#eaca89",
            green = "#96d382",
            teal = "#78cec1",
            sky = "#91d7e3",
            sapphire = "#68bae0",
            blue = "#739df2",
            lavender = "#a0a8f6",
            text = "#b5c1f1",
            subtext1 = "#a6b0d8",
            subtext0 = "#959ec2",
            overlay2 = "#848cad",
            overlay1 = "#717997",
            overlay0 = "#63677f",
            surface2 = "#505469",
            surface1 = "#3e4255",
            surface0 = "#2c2f40",
            base = "#1a1c2a",
            mantle = "#141620",
            crust = "#0e0f16",
        },
    },
}

require("tokyonight").setup {
    styles = {
        comments = { italic = false },
        keywords = { italic = false },
    }
}

require("onedark").setup {
    style = "deep"
}

-- TextToColorscheme()
-- SetColor("flexoki-dark")
-- SetColor("catppuccin")
-- SetColor("carbonfox")
-- SetColor("tokyonight-night")
-- SetColor("gruvbox")
-- SetColor("neofusion")
-- SetColor("onedark")
SetColor("kanagawa")
-- vim.o.background = "dark"
