return {
    on_init = function(client)
        client.server_capabilities.documentFormattingProvider = false

        if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then return end
        end

        local telescope_path = vim.api.nvim_get_runtime_file('lua/telescope/init.lua', false)[1]
        local library = {
            vim.env.VIMRUNTIME,
            -- For LSP Settings Type Annotations: https://github.com/neovim/nvim-lspconfig#lsp-settings-type-annotations
            vim.api.nvim_get_runtime_file('lua/lspconfig', false)[1],
            vim.fn.stdpath 'config',
        }

        if telescope_path then table.insert(library, vim.fs.dirname(telescope_path)) end

        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
                -- Tell the language server which version of Lua you're using (most
                -- likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
                -- Tell the language server how to find Lua modules same way as Neovim
                -- (see `:h lua-module-load`)
                path = {
                    'lua/?.lua',
                    'lua/?/init.lua',
                },
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
                checkThirdParty = false,
                library = library,
                -- Or pull in all of 'runtimepath'.
                -- NOTE: this is a lot slower and will cause issues when working on
                -- your own configuration.
                -- See https://github.com/neovim/nvim-lspconfig/issues/3189
                -- library = vim.api.nvim_get_runtime_file('', true),
            },
        })
    end,
    settings = {
        Lua = {
            format = { enable = false }, -- Disable formatting (formatting is done by stylua)
        },
    },
}
