-- python is linted by the ruff LSP (lsp.lua), not here
local lint = require("lint")

local wanted = {
	lua = { "luac" },
	sh = { "bash" },
	c = { "cppcheck" },
	rust = { "clippy" },
	css = { "stylelint" },
	html = { "htmlhint" },
}

local function linter_cmd(name)
	local linter = lint.linters[name]
	if type(linter) == "function" then
		linter = linter()
	end
	if type(linter) ~= "table" then
		return nil
	end
	local cmd = linter.cmd
	if type(cmd) == "function" then
		cmd = cmd()
	end
	return cmd
end

-- keep only installed linters, so saving a file never shows "ENOENT" errors
local available = {}
for ft, names in pairs(wanted) do
	for _, name in ipairs(names) do
		local cmd = linter_cmd(name)
		if cmd and vim.fn.executable(cmd) == 1 then
			available[ft] = available[ft] or {}
			table.insert(available[ft], name)
		end
	end
end
lint.linters_by_ft = available
