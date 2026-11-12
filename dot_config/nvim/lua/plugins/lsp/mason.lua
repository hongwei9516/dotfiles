require('mason').setup {}
require('mason-lspconfig').setup {
    automatic_enable = false,
    ensure_installed = { 'lua_ls' },
}

local registry = require('mason-registry')
local function ensure_tools()
    local tools = { 'stylua' }
    for _, tool in ipairs(tools) do
        local ok, pkg = pcall(registry.get_package, tool)
        if ok and not pkg:is_installed() then
            pkg:install()
        end
    end
end
registry.refresh(ensure_tools)

local servers = {
    lua_ls = require('plugins.lsp.settings.lua_ls')
}

for name, config in pairs(servers) do
    vim.lsp.config(name, config)
    vim.lsp.enable(name)
end
