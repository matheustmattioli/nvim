-- auto install vim-plug and plugins, if not found
local data_dir = vim.fn.stdpath("data")
if vim.fn.empty(vim.fn.glob(data_dir .. "/site/autoload/plug.vim")) == 1 then
	vim.cmd(
		"silent !curl -fLo "
			.. data_dir
			.. "/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
	)
	vim.o.runtimepath = vim.o.runtimepath
	vim.cmd("autocmd VimEnter * PlugInstall --sync | source $MYVIMRC")
end

local vim = vim
local Plug = vim.fn["plug#"]

vim.g.start_time = vim.fn.reltime()
vim.loader.enable()
vim.call("plug#begin")

Plug("catppuccin/nvim", { ["as"] = "catppuccin" })
Plug("ellisonleao/gruvbox.nvim", { ["as"] = "gruvbox" })
Plug("uZer/pywal16.nvim", { ["as"] = "pywal16" })
Plug("nvim-lualine/lualine.nvim")
Plug("nvim-tree/nvim-web-devicons")
Plug("folke/which-key.nvim")
Plug("romgrk/barbar.nvim")
Plug("goolord/alpha-nvim")
Plug("nvim-treesitter/nvim-treesitter")
Plug("mfussenegger/nvim-lint")
Plug("nvim-tree/nvim-tree.lua")
Plug("windwp/nvim-autopairs")
Plug("lewis6991/gitsigns.nvim")
Plug("numToStr/Comment.nvim")
Plug("catgoose/nvim-colorizer.lua") --color highlight (maintained fork of norcalli's)
Plug("ibhagwan/fzf-lua")
Plug("numToStr/FTerm.nvim")
Plug("ron-rs/ron.vim") --ron syntax highlighting
Plug("MeanderingProgrammer/render-markdown.nvim")
Plug("emmanueltouzery/decisive.nvim") --view csv files
Plug("folke/twilight.nvim")

Plug("lukas-reineke/indent-blankline.nvim")
Plug("folke/snacks.nvim")
Plug("oxfist/night-owl.nvim")
Plug("nhattVim/alpha-ascii.nvim")
Plug("lewis6991/gitsigns.nvim")
Plug("zbirenbaum/copilot.lua")
Plug("copilotlsp-nvim/copilot-lsp") -- copilot dep
Plug("stevearc/conform.nvim")

Plug("neovim/nvim-lspconfig")
Plug("hrsh7th/cmp-nvim-lsp")
Plug("hrsh7th/cmp-buffer")
Plug("hrsh7th/cmp-path")
Plug("hrsh7th/cmp-cmdline")
Plug("hrsh7th/nvim-cmp")
Plug("hrsh7th/cmp-vsnip")
Plug("hrsh7th/vim-vsnip")

Plug("linux-cultist/venv-selector.nvim")

Plug("nvim-lua/plenary.nvim") -- lua library used by several plugins
Plug("danymat/neogen") -- generate docstrings (<leader>pd)

vim.call("plug#end")

require("config.theme")
require("config.mappings")
require("config.options")
require("config.autocmd")

require("plugins.alpha-ascii")
require("plugins.alpha")
require("plugins.barbar")
require("plugins.colorizer")
require("plugins.colorscheme")
require("plugins.comment")
require("plugins.gitsigns")
require("plugins.lualine")
require("plugins.nvim-lint")
require("plugins.render-markdown")
require("plugins.treesitter") -- not deferred: the FileType autocmd must exist before the first buffer opens

require("config.indentblankline")
require("plugins.snacks")
require("plugins.gitsigns")
require("plugins.copilot")
require("plugins.cmp")
require("plugins.lsp")
require("plugins.neogen")
require("plugins.sshfs")
require("plugins.venv-selector")
require("plugins.conform")

vim.defer_fn(function()
	require("plugins.autopairs")
	require("plugins.fterm")
	require("plugins.fzf-lua")
	require("plugins.nvim-tree")
	require("plugins.twilight")
	require("plugins.which-key")
end, 100)

load_theme()
