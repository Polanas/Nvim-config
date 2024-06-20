local hydra = require("hydra")

hydra({
    name = "Resize window",
    config = {},
    mode = "n",
    body = "<leader>z",
    heads = {
        {"j", "<C-w>+"},
        {"k", "<C-w>-"},
        {"h", "<C-w><"},
        {"l", "<C-w>>"},
    },
})
