local map = require('utils').map

------------------------------- Nomarl Mode(n) ------------------------------
-- Save Quit Restart and Nohl
map('<leader>w', '<cmd>write<cr>', 'Save')
map('<leader>q', '<cmd>quit<cr>', 'Quit')
map('<leader>h', '<cmd>nohl<cr>', 'Nohl')
map('<leader>rl', '<cmd>restart<cr>', 'Restart')
map('<leader>re', '<cmd>e<cr>', 'Reload File')

-- Buffr
map('<S-h>', '<cmd>bprevious<cr>', 'Previous Buffer')
map('<S-l>', '<cmd>bnext<cr>', 'Next Buffer')
map('<leader>bd', '<cmd>bdelete<cr>', 'Close Buffer')

-- Window Navigation
map('<C-h>', '<C-w>h', 'Focus Left Window')
map('<C-j>', '<C-w>j', 'Focus Below Window')
map('<C-k>', '<C-w>k', 'Focus Above Window')
map('<C-l>', '<C-w>l', 'Focus Right Window')

-- Window Resize
map('<C-D-h>', '<cmd>vertical resize -2<cr>', 'Resize Left')
map('<C-D-j>', '<cmd>resize +2<cr>', 'Resize Down')
map('<C-D-k>', '<cmd>resize -2<cr>', 'Resize Up')
map('<C-D-l>', '<cmd>vertical resize +2<cr>', 'Resize Right')

-- Move Text
map('<A-n>', '<cmd>m .+1<cr>==', 'Move Text Down')
map('<A-m>', '<cmd>m .-2<cr>==', 'Move Text Up')

map('<leader>m', function() require('custom.bookmark').open() end, 'Bookmarks')

map('J', 'mzJ`z', 'Join lines without moving cursor')

map('<C-d>', '<C-d>zz', 'move down in buffer with cursor centered')
map('<C-u>', '<C-u>zz', 'move up in buffer with cursor centered')

map('n', 'nzzzv', 'Next search result cursor centered')
map('N', 'Nzzzv', 'Previous search result cursor centered')

map('<leader>rw', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], 'Replace word cursor is on globally', { silent = false })

map('<leader>tu', function()
    vim.cmd.packadd 'nvim.undotree'
    require('undotree').open()
end, 'Toggle Builtin Undotree')

map('<leader>m', function() require('custom.bookmark').open() end, 'Bookmarks')
map('<leader>M', function() require('custom.bookmark').add() end, 'Add Bookmark')

------------------------------- Insert Mode(i) ------------------------------
map('jk', '<esc>', 'Exit Insert Mode', nil, 'i')

------------------------------- Visual Mode(v) ------------------------------
-- Move Text
map('<A-n>', "<cmd>m '>+1<cr>gv=gv", 'Move Text Down', nil, 'v')
map('<A-m>', "<cmd>m '<-2<cr>gv=gv", 'Move Text Up', nil, 'v')

-- Stay in Indent
map('<', '<gv^', 'Stay in Indent', nil, 'v')
map('>', '>gv^', 'Stay in Indent', nil, 'v')

-- Paste without overwriting Register
map('p', '"_dP', 'Paste without overwriting Register', nil, 'v')

map('<leader>t', function()
    -- 获取 Visual Mode 选中的文本
    local text = table.concat(vim.fn.getregion(vim.fn.getpos 'v', vim.fn.getpos '.', { type = vim.fn.mode() }), '\n')

    if text == '' then return end

    -- 构造 Bob API 请求
    local request = vim.json.encode {
        path = 'translate',
        body = {
            action = 'translateText',
            text = text,
        },
    }

    -- 直接调用 Bob，不经过系统剪贴板
    vim.fn.jobstart({
        'osascript',
        '-e',
        string.format('tell application id "com.hezongyidev.Bob" to request %q', request),
    }, { detach = true })
end, 'Translate with Bob', nil, 'v')

map('q', '<esc>', 'Exit Visual Mode', nil, 'v')
---------------------------- Visual Block Mode(x) ---------------------------
-- Move Text
map('<A-n>', "<cmd>m '>+1<cr>gv=gv", 'Move Text Down', nil, 'x')
map('<A-m>', "<cmd>m '<-2<cr>gv=gv", 'Move Text Up', nil, 'x')

-------------------------------- Term Mode(t) -------------------------------
map('<C-h>', '<C-\\><C-N><C-w>h', 'Focus Left Terminal', nil, 't')
map('<C-j>', '<C-\\><C-N><C-w>j', 'Focus Below Terminal', nil, 't')
map('<C-k>', '<C-\\><C-N><C-w>k', 'Focus Above Terminal', nil, 't')
map('<C-l>', '<C-\\><C-N><C-w>l', 'Focus Right Terminal', nil, 't')

------------------------------- Command Mode(c) -----------------------------
