local M = {}

local data_home = vim.env.XDG_DATA_HOME
if not data_home or data_home == '' then data_home = vim.env.HOME .. '/.local/share' end
local db_dir = data_home .. '/fav'
local db_path = db_dir .. '/fav.sqlite3'
local db

local function get_db()
    if db then return db end

    vim.fn.mkdir(db_dir, 'p')

    local sqlite = require 'sqlite'
    db = sqlite.new(db_path)
    db:open()

    db:eval [[
        CREATE TABLE IF NOT EXISTS favorite_files (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            path TEXT NOT NULL UNIQUE,
            category TEXT NOT NULL DEFAULT 'Other',
            created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
        )
    ]]

    return db
end

local function get_all()
    local rows = get_db():eval [[
        SELECT id, name, path, category, created_at
        FROM favorite_files
        ORDER BY category, name
    ]]
    return type(rows) == 'table' and rows or {}
end

-- 添加当前文件到书签
function M.add()
    local path = vim.api.nvim_buf_get_name(0)
    if path == '' or vim.bo.buftype ~= '' then
        vim.notify('当前缓冲区不是有效文件，无法添加书签', vim.log.levels.WARN)
        return
    end

    path = vim.fn.fnamemodify(path, ':p')
    local default_name = vim.fn.fnamemodify(path, ':t')

    vim.ui.input({ prompt = 'Bookmark Name: ', default = default_name }, function(name)
        if not name or name == '' then return end

        vim.ui.input({ prompt = 'Category: ', default = 'Other' }, function(category)
            if not category or category == '' then category = 'Other' end

            local database = get_db()
            database:eval(
                string.format(
                    "INSERT INTO favorite_files (name, path, category) VALUES ('%s', '%s', '%s') ON CONFLICT(path) DO UPDATE SET name=excluded.name, category=excluded.category;",
                    name:gsub("'", "''"),
                    path:gsub("'", "''"),
                    category:gsub("'", "''")
                )
            )
            vim.notify(string.format('Saved bookmark: [%s] %s', category, name), vim.log.levels.INFO)
        end)
    end)
end

-- 打开书签列表（支持回车打开，Ctrl+d 删除）
function M.open()
    local entries = get_all()

    if vim.tbl_isempty(entries) then
        vim.notify('No bookmarks found', vim.log.levels.INFO)
        return
    end

    if _G.load_telescope then _G.load_telescope() end
    local pickers = require 'telescope.pickers'
    local finders = require 'telescope.finders'
    local conf = require('telescope.config').values
    local actions = require 'telescope.actions'
    local action_state = require 'telescope.actions.state'

    local function make_finder(items)
        return finders.new_table {
            results = items,
            entry_maker = function(entry)
                return {
                    value = entry,
                    display = string.format('%-12s %s', '[' .. entry.category .. ']', entry.name),
                    ordinal = entry.category .. ' ' .. entry.name .. ' ' .. entry.path,
                    filename = entry.path,
                }
            end,
        }
    end

    pickers
        .new({}, {
            prompt_title = 'Bookmarks (<CR>: Open | <C-d>: Delete)',
            finder = make_finder(entries),
            sorter = conf.generic_sorter {},

            attach_mappings = function(prompt_bufnr, map_key)
                -- 默认回车打开文件
                actions.select_default:replace(function()
                    local selection = action_state.get_selected_entry()
                    actions.close(prompt_bufnr)
                    if selection then vim.cmd.edit(vim.fn.fnameescape(selection.value.path)) end
                end)

                -- 按 <C-d> 直接从 SQLite 删除该书签并刷新当前列表
                local delete_bookmark = function()
                    local selection = action_state.get_selected_entry()
                    if not selection then return end

                    get_db():eval(string.format('DELETE FROM favorite_files WHERE id = %d;', selection.value.id))
                    vim.notify('Deleted bookmark: ' .. selection.value.name, vim.log.levels.INFO)

                    local picker = action_state.get_current_picker(prompt_bufnr)
                    local updated = get_all()
                    if vim.tbl_isempty(updated) then
                        actions.close(prompt_bufnr)
                    else
                        picker:refresh(make_finder(updated), { reset_prompt = false })
                    end
                end

                map_key('i', '<C-d>', delete_bookmark)
                map_key('n', '<C-d>', delete_bookmark)

                return true
            end,
        })
        :find()
end

return M
