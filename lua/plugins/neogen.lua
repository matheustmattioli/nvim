-- pcall: on the first start, before :PlugInstall, neogen isn't installed yet
local ok, neogen = pcall(require, "neogen")
if not ok then
	return
end

neogen.setup({
	snippet_engine = "vsnip",
	languages = {
		python = {
			template = {
				annotation_convention = "google_docstrings", -- or "numpydoc" / "reST"
			},
		},
	},
})
