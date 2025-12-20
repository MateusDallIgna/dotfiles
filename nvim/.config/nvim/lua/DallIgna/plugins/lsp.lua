return {
    { "neovim/nvim-lspconfig" },

    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },

    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "mason.nvim", "neovim/nvim-lspconfig" },
        config = function()
            local mason_lspconfig = require("mason-lspconfig")

            vim.diagnostic.config({
                virtual_text = true,
                signs = true,
                underline = true,
                update_in_insert = false,
                severity_sort = true,
                float = { border = "rounded", source = "always" },
            })

            local servers_to_install = {"lua_ls", "pyright", "rust_analyzer", "clangd"}

            mason_lspconfig.setup({
                ensure_installed = { "lua_ls", "pyright", "rust_analyzer", "clangd" },
            })
            for _, servers_name in ipairs(servers_to_install) do
                vim.lsp.enable(servers_name)
            end
            vim.lsp.config["lua_ls"] = {
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" },
                        },
                    },
                }
            }
        end,
    },
}
