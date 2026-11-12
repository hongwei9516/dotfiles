local opts = {
    ---Highlight named colors, e.g. 'green'
    enable_named_colors = false,
}
vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile' }, {
    group = vim.api.nvim_create_augroup('SetupNvimHighlightColor', { clear = true }),
    once = true,
    callback = function() require('nvim-highlight-colors').setup(opts) end,
})
