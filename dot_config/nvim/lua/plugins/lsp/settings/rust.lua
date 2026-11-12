-- rustaceanvim 配置
-- 修复：新建文件（`文件还不存在于磁盘`）时 LSP 不 attach 的问题。
--
-- 原因：rustaceanvim 默认的 root 检测（default_get_root_dir）会先
-- `vim.uv.fs_stat(文件名)`，文件不存在时直接 return nil 且不回调，
-- 于是客户端永远不启动；保存文件后也没有任何机制重试。
--
-- 解决：自定义 root_dir，从文件所在目录向上查找 Cargo.toml /
-- rust-project.json。目录总是存在的（即使是新文件），所以能找到项目根。
vim.g.rustaceanvim = {
    server = {
        capabilities = require('blink.cmp').get_lsp_capabilities(),
        root_dir = function(filename, default)
            if filename == '' then return default(filename) end
            return vim.fs.root(vim.fs.dirname(filename), { 'Cargo.toml', 'rust-project.json' }) or default(filename)
        end,
        default_settings = {
            ['rust-analyzer'] = {
                -- 用 clippy 替代 cargo check，保存时输出更多 lint
                -- （rustup 默认 profile 自带 clippy；如未安装可删除此配置）
                check = { command = 'clippy' },
                procMacro = {
                    enable = true,
                },
            },
        },
    },
}
