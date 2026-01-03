local treesj = require('treesj')
treesj.setup()

vim.keymap.set('n', '<leader>j', treesj.toggle, {silent = true})
