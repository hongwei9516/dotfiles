vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile' }, {
    group = vim.api.nvim_create_augroup('SetupTodoComments', { clear = true }),
    once = true,
    callback = function()
        require('todo-comments').setup { signs = false }
    end,
})

