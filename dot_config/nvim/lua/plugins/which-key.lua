require('which-key').setup {
    preset = 'modern',
    delay = 300,
    spec = {
        -- Buffer and Search
        { '<leader>b', group = 'Buffer' },
        { '<leader>s', group = 'Search', mode = { 'n', 'v' } },

        -- Ui and Terminal
        { '<leader>u', group = 'Ui' },
        { '<leader>t', group = 'Terminal' },

        -- Reload
        { '<leader>r', group = 'Reload', icon = { icon = '󰑓 ', color = 'red' } },

        -- Code
        { '<leader>l', group = 'LSP', mode = { 'n', 'v' }, icon = { icon = ' ', color = 'cyan' } },
        { 'g', group = 'Jump' },
        { '<leader>o', group = 'Overseer' },

        -- Git
        { '<leader>g', group = 'Git', mode = { 'n', 'v' } },

        -- Icon
        { '<leader>w', icon = '󰈚 ' },
        { '<leader>h', icon = '󰛐 ' },

        { '<leader>m', icon = ' ' },
        { '<leader>M', icon = ' ' },
    },
}
