-- Group names (<leader>f = find, ...) are defined in lua/plugins/which-key.lua.

local function map(mode, lhs, rhs, desc, opts)
	opts = vim.tbl_extend("force", { silent = true, desc = desc }, opts or {})
	vim.keymap.set(mode, lhs, rhs, opts)
end

local function lazy(mod, fn, ...)
	local args = { ... }
	return function()
		require(mod)[fn](unpack(args))
	end
end

-- Leader ----------------------------------------------------------------------
map("", "<Space>", "<Nop>", "leader")
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Top level (most used) -------------------------------------------------------
map("n", "<leader>w", "<cmd>write<cr>", "write file")
map("n", "<leader>q", function() Snacks.bufdelete.delete() end, "close buffer")
map("n", "<leader>Q", function() Snacks.bufdelete.delete({ force = true }) end, "close buffer (discard changes)")
map("n", "<leader>e", "<cmd>NvimTreeFindFileToggle<cr>", "file tree (at current file)")
map("n", "<leader>R", "<cmd>source %<cr>", "source current file")
map("n", "<leader>h", "<cmd>Alpha<cr>", "home (dashboard)")
map("v", "<leader>i", "=gv", "re-indent selection")

-- Buffers: Shift-h/l cycle, Alt-1..9 jump, Alt-Shift-h/l move, Alt-p pin -------
map("n", "<S-l>", "<cmd>bnext<cr>", "next buffer")
map("n", "<S-h>", "<cmd>bprevious<cr>", "previous buffer")
map("n", "<A-S-h>", "<cmd>BufferMovePrevious<cr>", "move buffer left")
map("n", "<A-S-l>", "<cmd>BufferMoveNext<cr>", "move buffer right")
for i = 1, 9 do
	map("n", "<A-" .. i .. ">", "<cmd>BufferGoto " .. i .. "<cr>", "go to buffer " .. i)
end
map("n", "<A-0>", "<cmd>BufferLast<cr>", "go to last buffer")
map("n", "<A-p>", "<cmd>BufferPin<cr>", "pin buffer")

local function rename_file()
	local old = vim.api.nvim_buf_get_name(0)
	if old == "" then
		vim.notify("Buffer has no file", vim.log.levels.WARN)
		return
	end
	vim.ui.input({ prompt = "Move/rename to: ", default = old, completion = "file" }, function(new)
		if not new or new == "" or new == old then
			return
		end
		vim.fn.mkdir(vim.fs.dirname(new), "p")
		vim.cmd.saveas({ new, bang = true })
		vim.fn.delete(old)
		local old_buf = vim.fn.bufnr(old)
		if old_buf > 0 then
			vim.cmd.bwipeout(old_buf)
		end
	end)
end

map("n", "<leader>bd", function() Snacks.bufdelete.delete() end, "delete buffer")
map("n", "<leader>bD", function() Snacks.bufdelete.delete({ force = true }) end, "delete buffer (discard changes)")
map("n", "<leader>bo", function() Snacks.bufdelete.other() end, "close other buffers")
map("n", "<leader>ba", function() Snacks.bufdelete.all() end, "close all buffers")
map("n", "<leader>bv", "<cmd>vsplit | bnext<cr>", "vsplit + next buffer")
map("n", "<leader>bs", ":saveas ", "save as (copy to new name)", { silent = false })
map("n", "<leader>bm", rename_file, "move / rename file")

-- Windows: Ctrl-hjkl move, F5-F8 resize ----------------------------------------
map("n", "<C-h>", "<C-w>h", "window left")
map("n", "<C-j>", "<C-w>j", "window down")
map("n", "<C-k>", "<C-w>k", "window up")
map("n", "<C-l>", "<C-w>l", "window right")
map("n", "<F5>", "<cmd>resize +2<cr>", "taller window")
map("n", "<F6>", "<cmd>resize -2<cr>", "shorter window")
map("n", "<F7>", "<cmd>vertical resize +2<cr>", "wider window")
map("n", "<F8>", "<cmd>vertical resize -2<cr>", "narrower window")

-- Find (fzf-lua) ---------------------------------------------------------------
local config_dir = vim.fn.stdpath("config")
map("n", "<leader>ff", lazy("fzf-lua", "files"), "files (cwd)")
map("n", "<leader>fh", lazy("fzf-lua", "files", { cwd = "~" }), "files (home)")
map("n", "<leader>fc", lazy("fzf-lua", "files", { cwd = config_dir }), "files (nvim config)")
map("n", "<leader>fp", lazy("fzf-lua", "files", { cwd = ".." }), "files (parent dir)")
map("n", "<leader>fo", lazy("fzf-lua", "oldfiles"), "recent files")
map("n", "<leader>fb", lazy("fzf-lua", "buffers"), "open buffers")
map("n", "<leader>fg", lazy("fzf-lua", "live_grep"), "grep (live)")
map("n", "<leader>fw", lazy("fzf-lua", "grep_cword"), "grep word under cursor")
map("n", "<leader>fr", lazy("fzf-lua", "resume"), "resume last search")
map("n", "<leader>fk", lazy("fzf-lua", "keymaps"), "keymaps")
map("n", "<leader>/", function()
	require("fzf-lua").blines({
		winopts = { height = 0.35, width = 0.60, row = 0.95, border = "rounded" },
	})
end, "fuzzy search in buffer")

-- Search: native "/" and "?" (regex, motions like d/foo, n/N, cgn + .) ---------
-- <Esc> clears the highlight. Neovim's default for this is <C-l>,
-- but here <C-l> moves to the right window.
map("n", "<Esc>", "<cmd>nohlsearch<cr><Esc>", "clear search highlight")
map("n", "n", "nzzzv", "next match (centered)")
map("n", "N", "Nzzzv", "previous match (centered)")

-- Git (gitsigns + lazygit); ]h / [h jump between hunks -------------------------
local function hunk_jump(direction)
	return function()
		if vim.wo.diff then
			vim.cmd.normal({ direction == "next" and "]c" or "[c", bang = true })
		else
			require("gitsigns").nav_hunk(direction)
		end
	end
end

local function visual_range()
	return { vim.fn.line("."), vim.fn.line("v") }
end

map("n", "]h", hunk_jump("next"), "next git hunk")
map("n", "[h", hunk_jump("prev"), "previous git hunk")
map("n", "<leader>gg", function() Snacks.lazygit() end, "lazygit")
map("n", "<leader>gs", lazy("gitsigns", "stage_hunk"), "stage hunk")
map("n", "<leader>gr", lazy("gitsigns", "reset_hunk"), "reset hunk")
map("v", "<leader>gs", function() require("gitsigns").stage_hunk(visual_range()) end, "stage selected lines")
map("v", "<leader>gr", function() require("gitsigns").reset_hunk(visual_range()) end, "reset selected lines")
map("n", "<leader>gS", lazy("gitsigns", "stage_buffer"), "stage file")
map("n", "<leader>gR", lazy("gitsigns", "reset_buffer"), "reset file")
map("n", "<leader>gp", lazy("gitsigns", "preview_hunk"), "preview hunk")
map("n", "<leader>gi", lazy("gitsigns", "preview_hunk_inline"), "preview hunk inline")
map("n", "<leader>gb", lazy("gitsigns", "blame_line", { full = true }), "blame line")
map("n", "<leader>gd", lazy("gitsigns", "diffthis"), "diff vs index")
map("n", "<leader>gD", lazy("gitsigns", "diffthis", "~"), "diff vs last commit")
map("n", "<leader>gq", lazy("gitsigns", "setqflist"), "hunks to quickfix (file)")
map("n", "<leader>gQ", lazy("gitsigns", "setqflist", "all"), "hunks to quickfix (repo)")

-- Code (LSP keys are added in lsp.lua when a server attaches) ----------------
map({ "n", "x" }, "<leader>cf", function() require("conform").format({ async = true }) end, "format file/selection")

-- Python ------------------------------------------------------------------------
map("n", "<leader>pv", "<cmd>VenvSelect<cr>", "select venv")
map("n", "<leader>pd", lazy("neogen", "generate"), "generate docstring")

-- Remote (SSHFS-Win, see plugins/sshfs.lua) ------------------------------------
map("n", "<leader>rc", "<cmd>SshfsConnect<cr>", "connect (mount server)")
map("n", "<leader>rd", "<cmd>SshfsDisconnect<cr>", "disconnect")
map("n", "<leader>rs", "<cmd>SshfsStatus<cr>", "status")

-- Substitute: cursor ends inside the pattern, ready to type ---------------------
map("n", "<leader>ss", ":%s//g<Left><Left>", "substitute in file", { silent = false })
map("n", "<leader>sw", ":%s/<C-r><C-w>//gc<Left><Left><Left>", "substitute word under cursor", { silent = false })

-- Terminal (FTerm) ---------------------------------------------------------------
map("n", "<leader>tt", lazy("FTerm", "toggle"), "floating terminal")
map("n", "<leader>tb", function() _G.btop:toggle() end, "btop")

-- <Esc> hides the floating terminal, only inside FTerm buffers
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("user_fterm_keys", { clear = true }),
	pattern = { "FTerm", "fterm_btop" },
	callback = function(args)
		local close = args.match == "FTerm"
			and function() require("FTerm").close() end
			or function() _G.btop:close() end
		map("t", "<Esc>", close, "hide terminal", { buffer = args.buf })
	end,
})

-- UI toggles ---------------------------------------------------------------------
map("n", "<leader>ut", function() _G.switch_theme() end, "cycle theme")
map("n", "<leader>uw", "<cmd>set wrap!<cr>", "toggle wrap")
map("n", "<leader>ud", "<cmd>Twilight<cr>", "toggle dim (twilight)")
map("n", "<leader>un", function()
	vim.wo.relativenumber = not vim.wo.relativenumber
	vim.wo.number = true
end, "toggle relative numbers")

-- Plugins (vim-plug) -------------------------------------------------------------
map("n", "<leader>Pi", "<cmd>PlugInstall<cr>", "install")
map("n", "<leader>Pu", "<cmd>PlugUpdate<cr>", "update")
map("n", "<leader>Pc", "<cmd>PlugClean<cr>", "clean (remove unused)")

-- CSV (decisive.nvim): only in csv buffers, so ]c/[c keep their normal meaning elsewhere
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("user_csv_keys", { clear = true }),
	pattern = "csv",
	callback = function(args)
		local o = { buffer = args.buf }
		map("n", "<leader>Ca", lazy("decisive", "align_csv", {}), "align columns", o)
		map("n", "<leader>Cc", lazy("decisive", "align_csv_clear", {}), "clear alignment", o)
		map("n", "]c", lazy("decisive", "align_csv_next_col"), "next csv column", o)
		map("n", "[c", lazy("decisive", "align_csv_prev_col"), "previous csv column", o)
	end,
})

-- Comments: Ctrl-/ (terminals send it as <C-_>) --------------------------------
for _, key in ipairs({ "<C-/>", "<C-_>" }) do
	map("n", key, "gcc", "toggle comment", { remap = true })
	map("v", key, "gc", "toggle comment", { remap = true })
end
