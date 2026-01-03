-- -- Mason Setup
-- require("mason").setup()
-- require("mason-lspconfig").setup({
--     ensure_installed = {
--         "lua_ls",
--         "clangd",
--         "pyright",
--         "ansiblels"
--     }
-- })

-- -- LSP Attach Keybindings
-- local on_attach = function(_, _)
--     local opts = { noremap = true, silent = true }
--     vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
--     vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
--     vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, opts)
--     vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
-- end

-- -- LSP Capabilities
-- local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- -- LSP UI Handlers
-- local handlers = {
--     ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
-- }

-- -- Diagnostic Highlighting
-- vim.api.nvim_set_hl(0, "DiagnosticError", { fg = "#fb4934" }) -- Red for errors
-- vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = "#fabd2f" }) -- Yellow for warnings
-- vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = "#83a598" }) -- Blue for info
-- vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = "#8ec07c" }) -- Aqua for hints

-- -- General Diagnostic Config
-- vim.diagnostic.config({
--     virtual_text = true,
--     signs = false,
--     underline = true,
--     update_in_insert = true,
--     severity_sort = false,
-- })

-- -- Floating Window Styling
-- vim.api.nvim_set_hl(0, 'NormalFloat', { link = 'Normal' })
-- vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'none' })

-- -- CMP Setup
-- local cmp = require("cmp")

-- cmp.setup({
--     sources = {
--         {
--             name = 'buffer',
--             option = {
--                 get_bufnrs = function()
--                     return vim.api.nvim_list_bufs()
--                 end
--             }
--         },
--         { name = 'nvim_lsp' },
--         { name = 'luasnip' },
--         { name = 'path' },
--     },
--     window = {
--         completion = cmp.config.window.bordered(),
--         documentation = cmp.config.window.bordered(),
--     },
-- })

-- -- Snippet Loader
-- require("luasnip.loaders.from_vscode").lazy_load()


-- -- Used check if a lsp is needed to be downloaded
-- local function is_lsp_attached(name)
--     for _, client in ipairs(vim.lsp.get_active_clients()) do
--         if client.name == name then
--             return true
--         end
--     end
--     return false
-- end

-- -- LSP Server Setups
-- local lspconfig = require("lspconfig")

-- -- Lua LS
-- if not is_lsp_attached("lua_ls") then
--     lspconfig.lua_ls.setup({
--         handlers = handlers,
--         on_attach = on_attach,
--         capabilities = capabilities,
--         settings = {
--             Lua = {
--                 diagnostics = {
--                     globals = { 'vim' },
--                 },
--             },
--         },
--     })
-- end

-- --  C/C++, Python LSPs
-- for _, server in ipairs({ "clangd", "pyright" }) do
--     lspconfig[server].setup({
--         handlers = handlers,
--         on_attach = on_attach,
--         capabilities = capabilities,
--     })
-- end

-- -- Ansible LSP
-- if not is_lsp_attached("ansiblels") then
--     lspconfig.ansiblels.setup({
--         filetypes = { "yaml.ansible" },
--         handlers = handlers,
--         on_attach = on_attach,
--         capabilities = capabilities,
--         settings = {
--             ansible = {
--                 path = "ansible",
--             },
--             python = {
--                 interpreterPath = "python3",
--             },
--         },
--     })
-- end

-- mason setup
require("mason").setup()
require("mason-lspconfig").setup {
    ensure_installed = { "lua_ls", "clangd", "pyright", "ansiblels" },
    automatic_installation = true,
    automatic_enable = true,
}

-- vim.lsp.get_clients()
-- LSP keymaps
local on_attach = function(_, _)
    local map = vim.keymap.set
    map('n', 'gd', vim.lsp.buf.definition, {})
    map('n', 'gi', vim.lsp.buf.implementation, {})
    map('n', 'gr', require('telescope.builtin').lsp_references, {})
    map('n', 'K', vim.lsp.buf.hover, {})
end

-- Capabilities
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Diagnostic visuals
vim.api.nvim_set_hl(0, "DiagnosticError", { fg = "#fb4934" })
vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = "#fabd2f" })
vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = "#83a598" })
vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = "#8ec07c" })

vim.diagnostic.config({
    virtual_text = true,
    float = {
        border = "rounded"
    },
    signs = false,
    underline = true,
    update_in_insert = true,
    severity_sort = false,
})

-- Border styling
-- vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
-- vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })

-- Optional: ensure border colors match theme
vim.api.nvim_set_hl(0, 'NormalFloat', { link = 'Normal' })
vim.api.nvim_set_hl(0, 'FloatBorder', { fg = "#a89984", bg = "#282828" })

local handlers = {
  ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
  ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
}

-- Use this function to avoid duplicate LSP setup
local function setup_lsp(server, config)
    local active = vim.tbl_filter(function(client)
        return client.name == server
    end, vim.lsp.get_clients())
    if #active == 0 then
        require("lspconfig")[server].setup(config)
    end
end

-- lua_ls
setup_lsp("lua_ls", {
    handlers = handlers,
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = {
                globals = { "vim" },
            },
            workspace = {
                checkThirdParty = false,
                library = vim.api.nvim_get_runtime_file("", true),
            },
            telemetry = { enable = false },
        },
    },
})

-- Other language servers
setup_lsp("pyright", { handlers = handlers, on_attach = on_attach, capabilities = capabilities })
setup_lsp("clangd",  { handlers = handlers, on_attach = on_attach, capabilities = capabilities })
setup_lsp("ansiblels", {
    handlers = handlers,
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "yaml.ansible" },
    settings = {
        ansible = { path = "ansible" },
        python = { interpreterPath = "python3" }
    }
})

-- nvim-cmp
local cmp = require("cmp")
cmp.setup {
    sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "path" },
        { name = "buffer",
            option = {
                get_bufnrs = function()
                    return vim.api.nvim_list_bufs()
                end
            }
        },
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
}
require("luasnip.loaders.from_vscode").lazy_load()
