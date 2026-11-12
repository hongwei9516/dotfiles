vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
    callback = function() vim.hl.on_yank() end,
})

local function run_build(name, cmd, cwd)
    vim.system(cmd, { cwd = cwd }, function(result)
        vim.schedule(function()
            if result.code ~= 0 then
                local output = (result.stderr and result.stderr ~= '') and result.stderr or result.stdout or ''
                if output == '' then output = 'No output from build command.' end
                vim.notify(('Build failed for %s:\n%s'):format(name, output), vim.log.levels.ERROR)
            else
                vim.notify(('Build succeeded for %s'):format(name), vim.log.levels.INFO)
            end
        end)
    end)
end

local blink_building = false

function blink_build()
    if blink_building or vim.fn.executable 'cargo' ~= 1 then return end

    blink_building = true

    vim.notify('Building blink.cmp...', vim.log.levels.INFO)
    require('blink.cmp')
        .build()
        :map(function()
            vim.schedule(function() vim.notify('blink.cmp build finished! Please restart Neovim.', vim.log.levels.INFO) end)
        end)
        :catch(function()
            vim.schedule(function() vim.notify('Build failed for blink.cmp', vim.log.levels.ERROR) end)
        end)
end

vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
        local name = ev.data.spec.name
        local kind = ev.data.kind
        if kind ~= 'install' and kind ~= 'update' then return end

        if name == 'telescope-fzf-native.nvim' and vim.fn.executable 'make' == 1 then
            run_build(name, { 'make' }, ev.data.path)
            return
        end

        if name == 'blink.cmp' then
            pcall(vim.cmd.packadd, { 'blink.lib', bang = true })
            if not ev.data.active then vim.cmd.packadd { 'blink.cmp', bang = true } end
            blink_build()
            return
        end

        if name == 'nvim-treesitter' then
            if not ev.data.active then vim.cmd.packadd 'nvim-treesitter' end
            -- 放入 vim.schedule 中异步执行，避免阻塞 vim.pack 导致 timeout
            vim.schedule(function() vim.cmd 'TSUpdate' end)
            return
        end
    end,
})

vim.api.nvim_create_autocmd('VimEnter', {
    callback = function() vim.schedule(blink_build) end,
})
