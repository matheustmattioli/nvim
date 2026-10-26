local options = {
	laststatus = 3,
	ruler = false,
	showmode = false,
	showcmd = false,
	wrap = true,
	mouse = "a",
	clipboard = "unnamedplus",
	history = 100,
	swapfile = false,
	backup = false,
	undofile = true,
	cursorline = true,
	ttyfast = true,
	smoothscroll = true,
	title = true,
	
	number = true,
	relativenumber = true,
	numberwidth = 4,

	smarttab = true,
	cindent = true,
	autoindent = false,
	expandtab = true,
	shiftwidth = 4,
	tabstop = 4,

	foldmethod = "expr",
	foldlevel = 99, --disable folding, lower #s enable
	foldexpr = "v:lua.vim.treesitter.foldexpr()",

	termguicolors = true,

	ignorecase = true,
	smartcase = true,
	inccommand = "split", --live preview of :s replacements in a split

	conceallevel = 2, --markdown conceal
	concealcursor = "nc",

	splitkeep = 'screen', --stabilize window open/close
}

for k, v in pairs(options) do
	vim.opt[k] = v
end

vim.diagnostic.config({
	signs = false,
})

-- no plugin here uses the remote-plugin providers
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0
