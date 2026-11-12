-- 1. 图标模块：保持启动时直接加载（供 lualine、oil、telescope 等依赖使用）
require('mini.icons').setup()
MiniIcons.mock_nvim_web_devicons()

-- 2. 外置配置参数
local ai_opts = {
    -- NOTE: Avoid conflicts with the built-in incremental selection mappings on Neovim>=0.12 (see `:help treesitter-incremental-selection`)
    mappings = {
        around_next = 'aa',
        inside_next = 'ii',
    },
    n_lines = 500,
}

local surround_opts = {}

-- 3. 文本对象操作模块：打开文件时再延迟加载
vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile' }, {
    group = vim.api.nvim_create_augroup('SetupMiniTextobjects', { clear = true }),
    once = true,
    callback = function()
        -- Better Around/Inside textobjects (va), yiiq, ci')
        require('mini.ai').setup(ai_opts)

        -- Add/delete/replace surroundings (saiw), sd', sr)')
        require('mini.surround').setup(surround_opts)

        -- 高亮十六进制颜色代码（如 #ffffff, #3b82f6）
        local hipatterns = require 'mini.hipatterns'
        hipatterns.setup {
            highlighters = {
                hex_color = hipatterns.gen_highlighter.hex_color(),
            },
        }

        -- 关键兜底：确保首次触发事件的当前缓冲区立即渲染颜色高亮
        hipatterns.enable(0)
    end,
})
