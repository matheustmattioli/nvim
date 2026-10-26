require("Comment").setup({
	padding = true,
	sticky = true,
	ignore = nil,
	toggler = {
		line = "gcc",
		block = "gb",
	},
	opleader = {
		line = "gc",
		block = "gb",
	},
	extra = {
		above = "gcO",
		below = "gco",
		eol = "gcA",
	},
	mappings = {
		basic = true,
		extra = true,
	},
	-- Comment.nvim's treesitter lookup crashes on nvim 0.12 (get_parser returns nil)
	pre_hook = function()
		return vim.bo.commentstring
	end,
	post_hook = nil,
})
