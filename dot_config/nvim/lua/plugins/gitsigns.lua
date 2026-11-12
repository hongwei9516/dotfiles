local opts = {
    signs = {
        add = { text = '+' }, -- 新增行
        change = { text = '~' }, -- 修改行
        delete = { text = '_' }, -- 删除行
        topdelete = { text = '‾' }, -- 文件开头被删掉的行
        changedelete = { text = '~' }, -- 既修改又删除的行
    },

    on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'
        local map = require('utils').map

        -- 在 diff 视图中，直接使用原生的 ]c / [c 跳转
        -- 否则切换到上一处 / 下一处 hunk
        map(']c', function()
            if vim.wo.diff then
                vim.cmd.normal { ']c', bang = true }
            else
                gitsigns.nav_hunk 'next'
            end
        end, 'Next Change', { buf = bufnr })

        map('[c', function()
            if vim.wo.diff then
                vim.cmd.normal { '[c', bang = true }
            else
                gitsigns.nav_hunk 'prev'
            end
        end, 'Previous Change', { buf = bufnr })

        -- 选中一段行后，把选区对应的 hunk 提交到暂存区
        map('<leader>gs', function() gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end, 'Stage Hunk', { buf = bufnr }, 'v')

        -- 选中一段行后，把这段 hunk 从工作区撤销
        map('<leader>gr', function() gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end, 'Reset Hunk', { buf = bufnr }, 'v')

        -- 暂存当前光标所在的 hunk
        map('<leader>gs', gitsigns.stage_hunk, 'Stage Hunk', { buf = bufnr })
        -- 回退当前光标所在的 hunk
        map('<leader>gr', gitsigns.reset_hunk, 'Reset Hunk', { buf = bufnr })
        -- 暂存当前文件所有改动
        map('<leader>gS', gitsigns.stage_buffer, 'Stage Buffer', { buf = bufnr })
        -- 撤销当前文件所有改动
        map('<leader>gR', gitsigns.reset_buffer, 'Reset Buffer', { buf = bufnr })
        -- 预览当前 hunk 的差异
        map('<leader>gp', gitsigns.preview_hunk, 'Preview Hunk', { buf = bufnr })
        -- 在当前行内显示更细粒度的字词 diff
        map('<leader>gi', gitsigns.preview_hunk_inline, 'Preview Hunk Inline', { buf = bufnr })
        -- 显示当前行的 blame 信息，包含完整提交信息
        map('<leader>gb', function() gitsigns.blame_line { full = true } end, 'Blame Line', { buf = bufnr })
        -- 打开当前文件相对 index 的 diff
        map('<leader>gd', gitsigns.diffthis, 'Diff Against Index', { buf = bufnr })
        -- 打开当前文件相对最后一次提交的 diff
        map('<leader>gD', function() gitsigns.diffthis '~' end, 'Diff Against Last Commit', { buf = bufnr })
        -- 把所有 hunk 放进 quickfix list，范围覆盖整个仓库
        map('<leader>gQ', function() gitsigns.setqflist 'all' end, 'Hunk Quickfix List (all files in repo)', { buf = bufnr })
        -- 把当前文件的所有改动放进 quickfix list
        map('<leader>gq', gitsigns.setqflist, 'Hunk Quickfix List (all changes in this file)', { buf = bufnr })
        -- 开关：显示 / 隐藏当前行的 blame 信息
        map('<leader>gB', gitsigns.toggle_current_line_blame, 'Toggle Show Blame Line', { buf = bufnr })
        -- 开关：显示 / 隐藏单词级别的 diff
        map('<leader>gw', gitsigns.toggle_word_diff, 'Toggle Intra-line Word Diff', { buf = bufnr })

        -- `ih` 表示“hunk 内部”
        -- 可在 operator-pending 和 visual 模式中使用
        map('ih', gitsigns.select_hunk, 'Text Object Inside Hunk', { buf = bufnr }, { 'o', 'x' })
    end,
}

vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufNewFile' }, {
    group = vim.api.nvim_create_augroup('SetupGitsigns', { clear = true }),
    once = true,
    callback = function()
        -- vim.cmd.packadd('gitsigns.nvim')
        require('gitsigns').setup(opts)
    end,
})
