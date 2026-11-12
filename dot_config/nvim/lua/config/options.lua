vim.g.mapleader = ' '
-- after/ftplugin/rust.lua
-- vim.keymap.set('n', '<localleader>r', '<cmd>RustLsp run<cr>', {
--     buffer = true,
--     desc = 'Run Rust Project',
-- })
-- localleader + buffer = true 实现局部快捷键
vim.g.maplocalleader = ' '

-- netrw 顶部横幅
-- vim.g.netrw_banner = 0
-- 关闭加载 netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- 关闭内置括号闪烁高亮
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1

-- Disable unused providers.
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

vim.o.number = true
vim.o.relativenumber = true

-- 接入系统剪切板
-- 涉及系统调用，可能比较耗时
vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

-- \t 4个空格
vim.o.tabstop = 4
-- <tab> <bs> 4个空格
vim.o.softtabstop = 4
-- 缩进 4 个空格
vim.o.shiftwidth = 4
-- \t 转空格
vim.o.expandtab = true
-- 长文本多行显示时缩进对齐
vim.o.breakindent = true

vim.o.ignorecase = true
-- 包含大写字母时不忽略大小写
vim.o.smartcase = true

vim.o.splitright = true
vim.o.splitbelow = true

-- Neovim 在cursor没有移动多长时间后触发 CursorHold 或 CursorHoldI 事件
-- 很多插件会利用这些事件执行延迟操作，例如显示光标位置的信息、更新某些状态或触发自动检查
vim.o.updatetime = 250
-- 组合快捷键等待时间
vim.o.timeoutlen = 300

-- a -->  always
vim.o.mouse = 'a'
-- 高亮当前行
vim.o.cursorline = true
-- 滚动代码时，鼠标停留在距离上下多少行
vim.o.scrolloff = 8

vim.o.showmode = false
-- 多窗口公用一个状态栏
-- vim.o.laststatus = 3 -- 会被 lualine 覆盖，可以在 lualine 配置中设置 globalstatus = true
-- yes --> always
vim.o.signcolumn = 'yes'
-- 代码补全窗口边框风格
vim.o.winborder = 'rounded'

-- 存在未保存文件时，询问是否保存
vim.o.confirm = true

vim.o.backup = false
vim.o.swapfile = false
vim.o.undofile = true

-- eob --> end of buffer
vim.opt.fillchars:append { eob = ' ' }

-- 缩进是否统一
-- 行尾多余空格
-- 复制粘贴带来的隐藏空格
-- 代码格式问题更直观，`git diff` 也更干净
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- 诊断信息配置
vim.diagnostic.config {
    -- insert mode 下更新诊断信息
    update_in_insert = false,
    -- 按严重程度排序
    severity_sort = true,
    -- 多来源时显示来源信息
    float = { border = 'rounded', source = 'if_many' },
    -- 严重程序 WARN 及以上的代码设置下划线
    underline = { severity = { min = vim.diagnostic.severity.WARN } },

    -- 诊断信息显示在每行末尾
    virtual_text = true,
    -- 诊断信息显示在下一行，有指示线
    virtual_lines = false,

    -- 诊断跳转时自动显示信息浮窗
    jump = {
        on_jump = function(_, bufnr)
            vim.diagnostic.open_float {
                bufnr = bufnr,
                scope = 'cursor',
                focus = false,
            }
        end,
    },
}
