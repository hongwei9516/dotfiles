-- 1. 提前注册 LSP 键位监听（内部由 LspAttach 驱动，启动零开销且避免嵌套）
require 'plugins.lsp.keymaps'

-- 2. 打开实际文件时再初始化插件与语言服务器
vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufNewFile' }, {
    group = vim.api.nvim_create_augroup('SetupLSP', { clear = true }),
    once = true,
    callback = function()
        -- LSP 右下角加载动画
        require('fidget').setup {}

        -- Rust 设置
        require 'plugins.lsp.settings.rust'

        -- Mason 与语言服务器启用
        require 'plugins.lsp.mason'
    end,
})

