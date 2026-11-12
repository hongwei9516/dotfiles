local M = {}

---@param lhs string 按键
---@param rhs string|function 动作
---@param desc string 描述（which-key 显示）
---@param opts? table 额外选项（如 { buffer = bufnr }）
---@param mode? string|string[] 模式，默认 'n'
function M.map(lhs, rhs, desc, opts, mode)
    opts = vim.tbl_extend('force', {
        desc = desc,
        silent = true,
    }, opts or {})

    vim.keymap.set(mode or 'n', lhs, rhs, opts)
end

return M
