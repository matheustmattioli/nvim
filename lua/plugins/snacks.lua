-- snacks.nvim: ui toolkit

require("snacks").setup({
	input = {
		enabled = true, -- nicer floating input for opencode.ask()
		win = {
			backdrop = false, 
			border = "rounded",
		},
	},
    picker = {
        enabled = true,
    },
    bufdelete = {
        enabled = true,
    },
    notifier = {
        enabled = true,
    },
    lazygit = {
        enabled = true,
    },
    scroll = {
        enabled = true,
    },
})
