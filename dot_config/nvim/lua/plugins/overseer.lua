vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('SetupOverseer', { clear = true }),
    pattern = { 'rust', 'javascript' },
    once = true,
    callback = function()
        vim.keymap.set('n', '<leader>or', '<cmd>OverseerRun<cr>', { desc = 'Overseer: Run task' })
        vim.keymap.set('n', '<leader>ot', '<cmd>OverseerToggle<cr>', { desc = 'Overseer: Toggle task list' })
        vim.keymap.set('n', '<leader>ol', '<cmd>OverseerRestartLast<cr>', { desc = 'Overseer: Restart last task' })
        require('overseer').setup {}
    end,
})
