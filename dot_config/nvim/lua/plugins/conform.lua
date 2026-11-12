local opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
        local enabled_filetypes = {
            -- lua = true,
            -- python = true,
        }
        if enabled_filetypes[vim.bo[bufnr].filetype] then
            return { timeout_ms = 500 }
        else
            return nil
        end
    end,
    default_format_opts = {
        lsp_format = 'fallback',
    },
    formatters_by_ft = {
        -- NOTE 显式指定格式化工具
        lua = { 'stylua' },
    },
}

vim.keymap.set({ 'n', 'v' }, '<leader>lf', function() require('conform').format { async = true } end, { desc = 'Format' })

vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufNewFile' }, {
    group = vim.api.nvim_create_augroup('SetupConform', { clear = true }),
    once = true,
    callback = function() require('conform').setup(opts) end,
})
