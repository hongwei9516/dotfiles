local catppuccin = require 'catppuccin'
catppuccin.setup {
    transparent_background = true,
    float = {
        transparent = true,
        solid = false,
    },
    auto_integrations = false, -- 关闭自动扫描，避免触发懒加载插件提前加载
    integrations = {
        gitsigns = true,
        telescope = { enabled = true },
        blink_cmp = true,
        treesitter = true,
        mini = { enabled = true },
    },
}
vim.cmd.colorscheme 'catppuccin-nvim'

vim.keymap.set('n', '<leader>ut', function()
    local opts = vim.deepcopy(catppuccin.options)

    opts.transparent_background = not opts.transparent_background

    catppuccin.setup(opts)
    vim.cmd.colorscheme 'catppuccin-nvim'
end, { desc = 'Toggle transparent' })
