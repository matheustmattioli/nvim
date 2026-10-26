local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

local config_dir = vim.fn.stdpath("config"):gsub("\\", "/")

dashboard.section.header_gen = function()
	return dashboard.section.header.val
end

vim.api.nvim_create_autocmd("User", {
	pattern = "AlphaReady",
	callback = function()
		vim.cmd("AlphaAsciiRandom")
	end,
})

local icon = {
	new = "\u{f016}", -- nf-fa-file_o
	find = "\u{f0349}", -- nf-md-magnify
	recent = "\u{f1da}", -- nf-fa-history
	browse = "\u{f07c}", -- nf-fa-folder_open
	server = "\u{f048b}", -- nf-md-server
	config = "\u{f013}", -- nf-fa-cog
	keys = "\u{f11c}", -- nf-fa-keyboard_o
	plugins = "\u{f1e6}", -- nf-fa-plug
	quit = "\u{f0159}", -- nf-md-close_circle
}

dashboard.section.buttons.val = {
	dashboard.button("e", icon.new .. "  New file", "<cmd>ene <BAR> startinsert<CR>"),
	dashboard.button("f", icon.find .. "  Find file", "<cmd>lua require('fzf-lua').files()<CR>"),
	dashboard.button("r", icon.recent .. "  Recent files", "<cmd>lua require('fzf-lua').oldfiles()<CR>"),
	dashboard.button("t", icon.browse .. "  Browse cwd", "<cmd>NvimTreeOpen<CR>"),
	dashboard.button("s", icon.server .. "  Connect to server", "<cmd>SshfsConnect<CR>"),
	dashboard.button("c", icon.config .. "  Config", "<cmd>e " .. config_dir .. "/init.lua<CR>"),
	dashboard.button("m", icon.keys .. "  Mappings", "<cmd>e " .. config_dir .. "/lua/config/mappings.lua<CR>"),
	dashboard.button("p", icon.plugins .. "  Plugins", "<cmd>PlugInstall<CR>"),
	dashboard.button("q", icon.quit .. "  Quit", "<cmd>qa<CR>"),
}

dashboard.section.footer.val = function()
	return vim.g.startup_time_ms or "[[  ]]"
end

dashboard.section.buttons.opts.hl = "Keyword"
dashboard.opts.opts.noautocmd = true
alpha.setup(dashboard.opts)
