local opts = {
    keymap = {
        preset = 'enter',
    },
    snippets = { preset = 'default' },
    signature = { enabled = true },
    completion = {
        menu = {
            draw = {
                columns = { { 'kind_icon' }, { 'label', gap = 1 } },
                components = {
                    label = {
                        text = function(ctx) return require('colorful-menu').blink_components_text(ctx) end,
                        highlight = function(ctx) return require('colorful-menu').blink_components_highlight(ctx) end,
                    },
                },
            },
        },
    },
    cmdline = {
        enabled = true,
        -- keymap = {
        --     preset = 'inherit',
        --     ['<Tab>'] = { 'select_next', 'fallback' },
        --     ['<S-Tab>'] = { 'select_prev', 'fallback' },
        -- },
        completion = {
            menu = { auto_show = true },
            list = {
                selection = {
                    preselect = false, -- 不默认选中第 1 行
                    auto_insert = true, -- 按 Tab 选中哪一行，文本就实时同步到命令行
                },
            },
        },
    },
}

vim.api.nvim_create_autocmd({ 'InsertEnter', 'CmdlineEnter' }, {
    group = vim.api.nvim_create_augroup('SetupCompletion', { clear = true }),
    once = true,
    callback = function() require('blink.cmp').setup(opts) end,
})
