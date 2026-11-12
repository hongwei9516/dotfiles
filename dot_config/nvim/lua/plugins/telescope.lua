-- 将依赖 telescope 内部模块的配置表封装为函数，避免启动时触发 require
local function get_opts()
    local actions = require 'telescope.actions'
    return {
        defaults = {
            mappings = {
                i = {
                    ['<C-s>'] = actions.select_horizontal,
                    ['<C-v>'] = actions.select_vertical,
                },
                n = {
                    ['<C-s>'] = actions.select_horizontal,
                    ['<C-v>'] = actions.select_vertical,
                },
            },
        },

        pickers = {
            live_grep = {
                additional_args = function() return { '--hidden', '--glob', '!**/.git/*' } end,
            },
        },

        extensions = {
            ['ui-select'] = { require('telescope.themes').get_dropdown {} },
        },
    }
end

-- 单次初始化函数
local loaded = false
function _G.load_telescope()
    if loaded then return end
    loaded = true

    local telescope = require 'telescope'
    telescope.setup(get_opts())
    pcall(telescope.load_extension, 'fzf')
    pcall(telescope.load_extension, 'ui-select')
end

-- 辅助函数：先初始化 Telescope，再调用 builtin 方法
local function run_builtin(name, opts)
    return function()
        load_telescope()
        require('telescope.builtin')[name](opts)
    end
end

-- 1. 快捷键触发懒加载
local map = require('utils').map

map('<leader><leader>', run_builtin 'buffers', 'Buffers')
map('<leader>sf', run_builtin 'find_files', 'Files')
map('<leader>sr', run_builtin 'oldfiles', 'Recent Files')
map('<leader>sg', run_builtin 'live_grep', 'Grep')
map('<leader>sw', run_builtin 'grep_string', 'current Word', nil, { 'n', 'v' })
map('<leader>sd', run_builtin 'diagnostics', 'Diagnostics')
map('<leader>su', run_builtin 'resume', 'Resume')
map('<leader>ss', run_builtin 'builtin', 'Select Telescope')
map('<leader>sk', run_builtin 'keymaps', 'Keymaps')
map('<leader>sc', run_builtin 'commands', 'Commands')
map('<leader>sh', run_builtin 'help_tags', 'Help')

map('<leader>/', function()
    load_telescope()
    local dropdown = require('telescope.themes').get_dropdown { previewer = false }
    require('telescope.builtin').current_buffer_fuzzy_find(dropdown)
end, 'Fuzzily Search')

map(
    '<leader>s/',
    run_builtin('live_grep', {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
    }),
    'Search Open Files'
)

map(
    '<leader>sn',
    run_builtin('find_files', {
        cwd = vim.fn.stdpath 'config',
        follow = true,
    }),
    'Neovim Files'
)

-- 2. 兼容 ui-select 扩展：当 LSP Code Action 等功能首次调用 vim.ui.select 时自动加载 Telescope
---@diagnostic disable-next-line: duplicate-set-field
vim.ui.select = function(...)
    load_telescope()
    return vim.ui.select(...)
end
