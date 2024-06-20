local util = require "formatter.util"
require("formatter").setup {
    logging = true,
    log_level = vim.log.levels.WARN,
    filetype = {
        gd = {
            function()
                return {
                    exe = "gdformat",
                    args = {
                        util.get_current_buffer_file_path(),
                    },
                    stdin = true,
                }
            end
        },
    }
}
