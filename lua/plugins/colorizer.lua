require("colorizer").setup({
	filetypes = { "*" },
	user_default_options = {
		RGB = true,
		RRGGBB = true,
		RRGGBBAA = true,
		names = false, -- don't paint words like Blue or red
		rgb_fn = true,
		hsl_fn = true,
		css = false, -- would turn names back on
		css_fn = true,
		mode = "background",
	},
})
