local opts = {
    indent = {
        char = '▏',
        highlight = { 'Whitespace' },
    },
    scope = {
        show_start = false,
        show_end = false,
    },
}

vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile' }, {
    group = vim.api.nvim_create_augroup('SetupIndentBlankline', { clear = true }),
    once = true,
    callback = function()
        require('ibl').setup(opts)
    end,
})

