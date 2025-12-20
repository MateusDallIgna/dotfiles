return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	dependencies = { "williamboman/mason.nvim" },
	config = function()
		require("mason-tool-installer").setup({
			ensure_installed = {
				-- Formaters (for conform.nvim)
				"prettier", -- javascript, typescript, html, css, json, markdown
				"stylua", -- lua
				"black", -- python
				"clang-format", -- c, cpp
				--Liners
				"eslint", -- javascript, typescript
				"pylint", -- python
			},
			auto_update = true,
			run_on_start = true,
		})
	end,
}
