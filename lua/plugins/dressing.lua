require("dressing").setup({
    input = {
        border = "rounded"
    },
    select = {
        -- telescope = nil,
        telescope = {
            layout_config = {
                bottom_pane = {
                    height = 0.4,
                    preview_cutoff = 40,
                    prompt_position = "top",
                    width = 0.5
                },
                center = {
                    height = 0.4,
                    preview_cutoff = 40,
                    prompt_position = "top",
                    width = 0.5
                },
                cursor = {
                    height = 0.4,
                    preview_cutoff = 40,
                    prompt_position = "top",
                    width = 0.5
                },
                horizontal = {
                    height = 0.4,
                    preview_cutoff = 40,
                    prompt_position = "top",
                    width = 0.5
                },
                vertical = {
                    height = 0.4,
                    preview_cutoff = 40,
                    prompt_position = "top",
                    width = 0.5
                }
            },
            sorting_strategy = "ascending",
            selection_strategy = "follow",
        }
    }
})
