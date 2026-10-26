local parsers = {
	"bash", "c", "cpp", "css", "go", "html", "java", "javascript", "json",
	"latex", "lua", "markdown", "markdown_inline", "python", "query", "regex",
	"rust", "toml", "tsx", "typescript", "vim", "vimdoc", "yaml",
}

require("nvim-treesitter").install(parsers)

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
	callback = function(args)
		local lang = vim.treesitter.language.get_lang(args.match)
		if not lang or not vim.treesitter.language.add(lang) then
			return
		end
		vim.treesitter.start(args.buf, lang)
		vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})
