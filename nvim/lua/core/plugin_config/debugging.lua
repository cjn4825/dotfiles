local dap = require("dap")
local dapui = require("dapui")

dapui.setup()
require("mason").setup()
require("mason-nvim-dap").setup({
    ensure_installed = { "codelldb" },
    handlers = {},
})

dap.defaults.fallback.external_terminal = {
    command = '/usr/bin/kitty',
    args = {'-e'}
}

dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end

vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, {})
vim.keymap.set('n', '<leader>dc', dap.continue, {})
