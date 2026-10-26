-- disabled on purpose: dashboard (alpha), explorer (nvim-tree), image (unsupported in Windows Terminal)

require("snacks").setup({
	input = {
		enabled = true,
		win = {
			backdrop = false,
			border = "rounded",
		},
	},
	picker = { enabled = true },
	bufdelete = { enabled = true },
	notifier = { enabled = true },
	lazygit = { enabled = true },
	scroll = { enabled = true },
	bigfile = { enabled = true },
	quickfile = { enabled = true },
	words = { enabled = true },
})
