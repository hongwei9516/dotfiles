local function gh(repo) return 'https://github.com/' .. repo end

local plugins = {

    -- Catppuccin
    { src = gh 'catppuccin/nvim', name = 'catppuccin' },

    -- Which-key
    gh 'folke/which-key.nvim',

    -- nvim-mini
    gh 'nvim-mini/mini.nvim',

    -- Statuline
    gh 'nvim-lualine/lualine.nvim',

    -- Telescope
    gh 'nvim-lua/plenary.nvim',
    gh 'nvim-telescope/telescope.nvim',
    gh 'nvim-telescope/telescope-ui-select.nvim',

    -- LSP
    gh 'j-hui/fidget.nvim',
    gh 'neovim/nvim-lspconfig',
    gh 'mason-org/mason.nvim',
    gh 'mason-org/mason-lspconfig.nvim',
    { src = gh 'mrcjkb/rustaceanvim', version = vim.version.range '^9' },

    -- code runer and job management
    gh 'stevearc/overseer.nvim',

    -- Format
    gh 'stevearc/conform.nvim',

    -- Completions and Snippets
    gh 'rafamadriz/friendly-snippets',
    gh 'saghen/blink.lib',
    gh 'saghen/blink.cmp',
    gh "xzbdmw/colorful-menu.nvim",

    -- Treesitter
    gh 'nvim-treesitter/nvim-treesitter',

    -- Autopairs
    gh 'windwp/nvim-autopairs',

    -- Highlight todo, notes, etc in comments
    gh 'folke/todo-comments.nvim',

    -- Toggleterm
    { src = gh 'akinsho/toggleterm.nvim', version = vim.version.range '2.*' },

    -- File Tree
    gh 'stevearc/oil.nvim',
    -- gh 'benomahony/oil-git.nvim',

    -- Indent line
    gh 'lukas-reineke/indent-blankline.nvim',

    -- Git
    gh 'lewis6991/gitsigns.nvim',

    -- Sqlite
    gh 'kkharji/sqlite.lua',
}

if vim.fn.executable 'make' == 1 then table.insert(plugins, gh 'nvim-telescope/telescope-fzf-native.nvim') end

vim.pack.add(plugins)
