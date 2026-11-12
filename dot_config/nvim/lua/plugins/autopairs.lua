vim.api.nvim_create_autocmd('InsertEnter', {
    group = vim.api.nvim_create_augroup('SetupAutoPairs', { clear = true }),
    once = true,
    callback = function() require('nvim-autopairs').setup {} end,
})
