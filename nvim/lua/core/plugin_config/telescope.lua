local builtin = require('telescope.builtin')
local telescope = require('telescope')
local devicons = require("nvim-web-devicons")

devicons.setup()

vim.keymap.set('n', '<leader>f', builtin.find_files, {silent=true})
vim.keymap.set('n', '<leader>g', builtin.live_grep, {silent=true})
vim.keymap.set('n', '<leader>r', builtin.oldfiles, {silent=true})
vim.keymap.set("n", "<leader>b", ":Telescope file_browser path=%:p:h select_buffer=true<CR>", {silent=true})

telescope.setup {
    pickers = {
        find_files = {
            hidden = true,
        },
        live_grep = {
            additional_args = {"--hidden"}
        },
    },
     extensions = {
          file_browser = {
            auto_depth = true,
            display_stat = false,
            grouped = true,
            hide_parent_dir = false,
            select_buffer = true,
            hidden = true,
          },
    },
}
require("telescope").load_extension("file_browser")
telescope.load_extension('fzy_native')
