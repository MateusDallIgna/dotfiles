return{
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        require("conform").setup {
        formatters_by_ft = {
            lua = { "stylua" },
            c = { "clang-format" },
            cpp = { "clang-format" },
            go = { "gofmt" },
            rust = { "rustfmt" },
            python = { "black" },
            javascript = { "prettier" },
            typescript = { "prettier" },
            html = { "prettier" },
            css = { "prettier" },
            json = { "prettier" },
            markdown = { "prettier" },
        },
        format_on_save = {
            timeout_ms = 500,
            lsp_fallback = true,
            async = false,
            }
        }
    end,
}
