require("nvim-tree").setup({
renderer = {
	icons = {
		show = {
		file = true,
		folder = true,
		folder_arrow = false,
		git = true,
		},
	},
},
	view = {
		width = 25,
		side = 'left',
	},
	sync_root_with_cwd = true,
	respect_buf_cwd = true,
	update_cwd = true,
	update_focused_file = {
		enable = true,
		update_cwd = true,
		update_root = true,
	},
})

vim.g.nvim_tree_respect_buf_cwd = 1

