-- 使用 Lua 加载器（带缓存），移除默认 Nvim 加载器
vim.loader.enable()

-- 使用 Nvim 新 UI , g< 快捷键进入命令行面板
require('vim._core.ui2').enable {}

-- 基础参数
require 'config.options'
-- 键位映射
require 'config.keymaps'
-- 自动命令
require 'config.autocmds'
-- 自定义命令
require 'config.commands'

-- Pack 安装 插件并将插件路径加入到runtimepath
require 'pack'

-- 配色主题
require 'plugins.colorscheme'
-- 键位提示面板
require 'plugins.which-key'
-- 图标、ai、surround
require 'plugins.mini'
-- 状态栏
require 'plugins.lualine'
-- Telescope 选择器
require 'plugins.telescope'

-- LSP 语言服务器配置
require 'plugins.lsp'
-- 格式化
require 'plugins.conform'
-- 代码补全
require 'plugins.blink-cmp'
-- 语法解析
require 'plugins.treesitter'
-- Overseer
require 'plugins.overseer'

-- 符号自动配对
require 'plugins.autopairs'
-- Highlight todo, notes, etc in comments
require 'plugins.todo-comments'
-- 切换终端
require 'plugins.toggleterm'
-- File Tree
require 'plugins.oil'
-- Indent Line
require 'plugins.indentlune'
-- Git
require 'plugins.gitsigns'
