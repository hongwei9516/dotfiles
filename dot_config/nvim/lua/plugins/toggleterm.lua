-- 1. 外置配置参数（纯表定义，启动零开销）
local opts = {
    size = function(term)
        if term.direction == 'horizontal' then
            return 15
        elseif term.direction == 'vertical' then
            return math.floor(vim.o.columns * 0.4)
        end
    end,

    hide_numbers = true,
    shade_terminals = true,
    shading_factor = 2,

    start_in_insert = true,
    insert_mappings = true,
    terminal_mappings = true,

    persist_size = true,
    persist_mode = true,
    direction = 'float',

    close_on_exit = true,

    float_opts = {
        border = 'rounded',
        width = function() return math.floor(vim.o.columns * 0.8) end,
        height = function() return math.floor(vim.o.lines * 0.8) end,
    },
}

-- 2. 单次初始化封装函数
local loaded = false
function _G.load_toggleterm()
    if loaded then return end
    loaded = true

    -- 如果你在 vim.pack 中将其放入了 opt 目录，请取消下面这行的注释：
    -- vim.cmd.packadd('toggleterm.nvim')

    require('toggleterm').setup(opts)
end

-- 辅助函数：先初始化插件，再执行终端命令
local function exec_term(cmd)
    return function()
        load_toggleterm()
        vim.cmd(cmd)
    end
end

-- 3. 快捷键触发懒加载
local map = require('utils').map

-- 浮动终端
map('<leader>tf', exec_term 'ToggleTerm direction=float', 'Float Terminal')

-- 水平终端
map('<leader>tt', exec_term 'ToggleTerm direction=horizontal', 'Horizontal Terminal')

-- 垂直终端
map('<leader>tv', exec_term 'ToggleTerm direction=vertical', 'Vertical Terminal')

-- 新建终端
map('<leader>tn', function()
    local count = vim.v.count1
    load_toggleterm()
    vim.cmd(count .. 'ToggleTerm')
end, 'New Terminal')

-- LazyGit
map('<leader>gg', exec_term 'TermExec cmd="exec lazygit" direction=float close_on_exit=true', 'LazyGit')

-- 切换终端（同时支持 Normal 模式和 Terminal 模式）
map('<C-\\>', exec_term 'ToggleTerm', 'Toggle Terminal', nil, { 'n', 't' })

