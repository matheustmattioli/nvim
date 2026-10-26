require("conform").setup({
	formatters_by_ft = {
		python = { "ruff_organize_imports", "ruff_format" },
		lua = { "stylua" },
		javascript = { "prettierd", "prettier", stop_after_first = true },
		toml = { "taplo" },
		yaml = { "prettier" },
		json = { "prettier" },
		markdown = { "prettier" },
		sh = { "shfmt" },
		["_"] = { "trim_whitespace" },
	},
})
