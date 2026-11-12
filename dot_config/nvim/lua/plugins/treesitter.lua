local function treesitter_try_attach(buf, language)
    if not vim.api.nvim_buf_is_valid(buf) then return end

    if not vim.treesitter.language.add(language) then return end

    vim.treesitter.start(buf, language)

    local has_indent_query = vim.treesitter.query.get(language, 'indents') ~= nil

    if has_indent_query then vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" end
end

local initialized = false
local available_parsers

vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('SetupTreesitter', { clear = true }),
    callback = function(args)
        local buf, filetype = args.buf, args.match

        local language = vim.treesitter.language.get_lang(filetype)
        if not language then return end

        if vim.fn.executable 'tree-sitter' ~= 1 then
            return
        end

        local ts = require 'nvim-treesitter'

        -- 首次触发 FileType 时执行一次性初始化（安装基础解析器并缓存可用列表）
        if not initialized then
            initialized = true
            local parsers = { 'bash', 'diff', 'html', 'luadoc', 'rust' }
            ts.install(parsers)
            available_parsers = ts.get_available()
        end

        local installed_parsers = ts.get_installed 'parsers'

        if vim.tbl_contains(installed_parsers, language) then
            treesitter_try_attach(buf, language)
        elseif vim.tbl_contains(available_parsers, language) then
            ts.install(language):await(function() treesitter_try_attach(buf, language) end)
        else
            treesitter_try_attach(buf, language)
        end
    end,
})
