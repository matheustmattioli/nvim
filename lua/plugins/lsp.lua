-- pyright: types/hover, ruff: lint + quick fixes, lua_ls: this config. Formatting is conform's job.

vim.lsp.config("*", {
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

vim.lsp.config("pyright", {
	settings = {
		pyright = {
			disableOrganizeImports = true, -- ruff organizes imports; avoid two competing actions
		},
	},
})

vim.lsp.config("ruff", {})

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			diagnostics = { globals = { "vim", "Snacks" } },
			workspace = {
				checkThirdParty = false,
				library = { vim.env.VIMRUNTIME },
			},
		},
	},
})

vim.lsp.enable({ "pyright", "ruff", "lua_ls" })

local function apply_action(kind)
	vim.lsp.buf.code_action({
		context = { only = { kind }, diagnostics = {} },
		apply = true,
	})
end

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true }),
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if not client then
			return
		end
		local function map(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, { buffer = args.buf, silent = true, desc = desc })
		end

		map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "code action")
		map("n", "<leader>cr", vim.lsp.buf.rename, "rename symbol")
		map("n", "<leader>cd", vim.diagnostic.open_float, "line diagnostics")

		if client.name == "ruff" then
			-- pyright gives better hover docs; ruff's hover only explains lint rules
			client.server_capabilities.hoverProvider = false
			map("n", "<leader>pi", function() apply_action("source.organizeImports") end, "organize imports")
			map("n", "<leader>pf", function() apply_action("source.fixAll") end, "ruff fix all")
		end
	end,
})
