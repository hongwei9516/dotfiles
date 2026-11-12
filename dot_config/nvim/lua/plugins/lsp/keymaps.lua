local map = require('utils').map

map('<leader>li', '<cmd>checkhealth vim.lsp<cr>', 'LSP Health')

-- 辅助函数：确保 Telescope 已执行 setup() 再调用 builtin
local function telescope_builtin(name)
    return function()
        -- 触发你之前在 plugins/telescope.lua 中定义的初始化（如果已暴露为全局或模块方法）
        -- 或者直接触发一次任意兼容初始化，确保 setup() 和 fzf 扩展已加载
        if _G.load_telescope then _G.load_telescope() end
        require('telescope.builtin')[name]()
    end
end

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspAttach', { clear = true }),
    callback = function(ev)
        local opts = { buffer = ev.buf }

        -- 基础 LSP 操作
        map('gD', vim.lsp.buf.declaration, 'Declaration', opts)
        map('<leader>lr', vim.lsp.buf.rename, 'Rename', opts)
        map('<leader>la', vim.lsp.buf.code_action, 'Code Action', opts, { 'n', 'x' })
        map('<leader>ls', vim.lsp.buf.signature_help, 'Signature Help', opts)

        -- 诊断信息导航
        map('<leader>ll', vim.diagnostic.open_float, 'Diagnostic Float', opts)
        map('<leader>lq', vim.diagnostic.setloclist, 'Diagnostic List', opts)
        map('<leader>lj', function() vim.diagnostic.jump { count = 1 } end, 'Next Diagnostic', opts)
        map('<leader>lk', function() vim.diagnostic.jump { count = -1 } end, 'Previous Diagnostic', opts)

        -- Telescope 符号与跳转（确保触发完整 setup）
        map('gd', telescope_builtin 'lsp_definitions', 'Definition', opts)
        map('gi', telescope_builtin 'lsp_implementations', 'Implementation', opts)
        map('gr', telescope_builtin 'lsp_references', 'References', opts)
        map('gO', telescope_builtin 'lsp_document_symbols', 'Open Document Symbols', opts)
        map('gW', telescope_builtin 'lsp_dynamic_workspace_symbols', 'Open Workspace Symbols', opts)
        map('grt', telescope_builtin 'lsp_type_definitions', 'Type Definition', opts)

        local client = vim.lsp.get_client_by_id(ev.data.client_id)

        -- 光标停留高亮相同符号
        if client and client:supports_method('textDocument/documentHighlight', ev.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                buffer = ev.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                buffer = ev.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
                buffer = ev.buf,
                group = vim.api.nvim_create_augroup('lsp-detach', { clear = false }),
                callback = function(ev2)
                    vim.lsp.buf.clear_references()
                    vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = ev2.buf }
                end,
            })
        end

        -- 内联提示开关（补全 buffer 作用域）
        if client and client:supports_method('textDocument/inlayHint', ev.buf) then
            map(
                '<leader>lh',
                function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = ev.buf }, { bufnr = ev.buf }) end,
                'Toggle Inlay Hints',
                opts
            )
        end
    end,
})
