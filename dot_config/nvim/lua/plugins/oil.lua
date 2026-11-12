local opts = {
    win_options = {
        winbar = '%!v:lua.get_oil_winbar()',
    },

    keymaps = {
        ['<C-h>'] = false,
        ['<C-j>'] = false,
        ['<C-k>'] = false,
        ['<C-l>'] = false,
        ['<C-v>'] = { 'actions.select', opts = { vertical = true } },
        ['<C-s>'] = { 'actions.select', opts = { horizontal = true } },
        ['gr'] = { 'actions.refresh' },
    },
}

-- 声明 winbar 全局函数（纯函数定义，启动时零开销，只有打开 Oil 窗口渲染 winbar 时才会调用）
function _G.get_oil_winbar()
    local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
    local dir = require('oil').get_current_dir(bufnr)
    if dir then
        return vim.fn.fnamemodify(dir, ':~')
    else
        -- If there is no current directory (e.g. over ssh), just show the buffer name
        return vim.api.nvim_buf_get_name(0)
    end
end

-- 确保只初始化一次的封装函数
local loaded = false
local function load_oil()
    if loaded then return end
    loaded = true
    -- 如果你在 vim.pack 中将其放入了 opt 目录，请取消下面这行的注释：
    -- vim.cmd.packadd('oil.nvim')
    require('oil').setup(opts)
end

-- 触发方式 1：按下 '-' 快捷键时加载并打开父目录
vim.keymap.set('n', '-', function()
    load_oil()
    vim.cmd 'Oil'
end, { desc = 'Open parent directory' })

-- 触发方式 2：在终端直接运行 `nvim .` 或打开任意目录缓冲区时自动接管
vim.api.nvim_create_autocmd('BufEnter', {
    group = vim.api.nvim_create_augroup('SetupOilOnDir', { clear = true }),
    callback = function(args)
        local path = vim.api.nvim_buf_get_name(args.buf)
        if path ~= '' and vim.fn.isdirectory(path) == 1 then
            load_oil()
            -- 初始化完成后即可移除此监听，后续全部由 oil 自己接管
            vim.schedule(function()
                require('oil').open(path)
            end)
            return true
        end
    end,
})

