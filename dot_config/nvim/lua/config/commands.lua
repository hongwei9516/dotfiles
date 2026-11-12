-- 提取公共补全函数：获取所有已安装插件名并按前缀过滤
local function complete_plugins(arg_lead)
    local names = vim.tbl_map(function(p) return p.spec.name end, vim.pack.get())
    return vim.tbl_filter(function(name) return vim.startswith(name, arg_lead) end, names)
end

-- 安装插件（传入 Git URL，例如 :PackAdd https://github.com）
vim.api.nvim_create_user_command('PackAdd', function(args) vim.pack.add(args.fargs) end, {
    nargs = '+',
})

-- 删除指定插件（支持 Tab 补全）
vim.api.nvim_create_user_command('PackDel', function(args) vim.pack.del(args.fargs) end, {
    nargs = '+',
    complete = complete_plugins,
})

-- 更新插件（不带参数全量更新，带参数更新指定插件）
vim.api.nvim_create_user_command('PackUpdate', function(args)
    if #args.fargs > 0 then
        vim.pack.update(args.fargs)
    else
        vim.pack.update()
    end
end, {
    nargs = '*',
    complete = complete_plugins,
})

vim.api.nvim_create_user_command('PackCheck', function(args)
    local plugins = vim.pack.get()
    local filter = #args.fargs > 0 and vim.tbl_filter(function(p) return vim.tbl_contains(args.fargs, p.spec.name) end, plugins) or plugins

    if #filter == 0 then
        vim.api.nvim_echo({ { '✖ 未找到匹配的插件', 'DiagnosticError' } }, true, {})
        return
    end

    table.sort(filter, function(a, b) return a.spec.name < b.spec.name end)

    local chunks = {
        { string.format('📦 已安装插件状态 (%d 个):\n', #filter), 'Title' },
    }

    for _, p in ipairs(filter) do
        local icon = p.active and '✔ ' or '○ '
        local hl = p.active and 'DiagnosticOk' or 'DiagnosticWarn'
        local status = p.active and '[active]' or '[opt/inactive]'
        local version = p.spec.version and (' @ ' .. tostring(p.spec.version)) or ''

        table.insert(chunks, { '  ' .. icon, hl })
        table.insert(chunks, { p.spec.name, 'Identifier' })
        table.insert(chunks, { version .. ' ', 'String' })
        table.insert(chunks, { status .. '\n', 'Comment' })
    end

    vim.api.nvim_echo(chunks, true, {})
end, {
    nargs = '*',
    complete = complete_plugins,
    desc = 'Inspect installed plugins status and versions',
})

vim.api.nvim_create_user_command('PackClean', function(args)
    local inactives = vim.tbl_filter(function(p) return not p.active end, vim.pack.get())
    local filter = #args.fargs > 0 and vim.tbl_filter(function(p) return vim.tbl_contains(args.fargs, p.spec.name) end, inactives) or inactives

    if #filter == 0 then
        vim.api.nvim_echo({ { '✖ 未找到待清理的插件', 'DiagnosticOk' } }, true, {})
        return
    end

    local names = vim.tbl_map(function(p) return p.spec.name end, filter)
    vim.pack.del(names)
    vim.api.nvim_echo({ { '✔ 已清理插件: ' .. table.concat(names, ', '), 'DiagnosticOk' } }, true, {})
end, {
    nargs = '*',
    -- 仅补全未激活的插件，防止误输入正在使用的插件
    complete = function(arg_lead)
        local names = vim.iter(vim.pack.get())
            :filter(function(p) return not p.active end)
            :map(function(p) return p.spec.name end)
            :filter(function(name) return vim.startswith(name, arg_lead) end)
            :totable()
        return names
    end,
    desc = 'Clean inactive plugins',
})
