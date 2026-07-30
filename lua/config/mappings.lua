-- mappings, including plugins

local function map(m, k, v, opts)
	opts = opts or {}
	opts.noremap = true
	opts.silent = true
	vim.keymap.set(m, k, v, opts)
end

-- set leader
map("", "<Space>", "<Nop>")
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- buffers
map("n", "<S-l>", ":bnext<CR>")
map("n", "<S-h>", ":bprevious<CR>")
map("n", "<leader>q", function() Snacks.bufdelete.delete() end)
map("n", "<leader>Q", function() Snacks.bufdelete.delete({ force = true }) end)
map("n", "<leader>U", function() Snacks.bufdelete.all() Snacks.bufdelete.invisible()  end) --close all
map('n', '<leader>vs', ':vsplit<CR>:bnext<CR>') --ver split + open next buffer

-- buffer position nav + reorder
map('n', '<AS-h>', '<Cmd>BufferMovePrevious<CR>')
map('n', '<AS-l>', '<Cmd>BufferMoveNext<CR>')
map('n', '<A-1>', '<Cmd>BufferGoto 1<CR>')
map('n', '<A-2>', '<Cmd>BufferGoto 2<CR>')
map('n', '<A-3>', '<Cmd>BufferGoto 3<CR>')
map('n', '<A-4>', '<Cmd>BufferGoto 4<CR>')
map('n', '<A-5>', '<Cmd>BufferGoto 5<CR>')
map('n', '<A-6>', '<Cmd>BufferGoto 6<CR>')
map('n', '<A-7>', '<Cmd>BufferGoto 7<CR>')
map('n', '<A-8>', '<Cmd>BufferGoto 8<CR>')
map('n', '<A-9>', '<Cmd>BufferGoto 9<CR>')
map('n', '<A-0>', '<Cmd>BufferLast<CR>')
map('n', '<A-p>', '<Cmd>BufferPin<CR>')

-- windows - ctrl nav, fn resize
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")
map("n", "<F5>", ":resize +2<CR>")
map("n", "<F6>", ":resize -2<CR>")
map("n", "<F7>", ":vertical resize +2<CR>")
map("n", "<F8>", ":vertical resize -2<CR>")

-- fzf and grep
map("n", "<leader>f", ":lua require('fzf-lua').files()<CR>") --search cwd
map("n", "<leader>Fh", ":lua require('fzf-lua').files({ cwd = '~/' })<CR>") --search home
map("n", "<leader>Fc", ":lua require('fzf-lua').files({ cwd = '~/.config' })<CR>") --search .config
map("n", "<leader>Fl", ":lua require('fzf-lua').files({ cwd = '~/.local/src' })<CR>") --search .local/src
map("n", "<leader>Ff", ":lua require('fzf-lua').files({ cwd = '..' })<CR>") --search above
map("n", "<leader>Fr", ":lua require('fzf-lua').resume()<CR>") --last search
map("n", "<leader>g", ":lua require('fzf-lua').grep()<CR>") --grep
map("n", "<leader>G", ":lua require('fzf-lua').grep_cword()<CR>") --grep word under cursor
map("n", "/", function()
    require("fzf-lua").blines({
        winopts = {
            height = 0.35,
            width = 0.60,
            row = 0.95,
            border = "rounded",
        },
    })
end)

-- misc
map("n", "<leader>s", ":%s//g<Left><Left>") --replace all
map("n", "<leader>sr", ":%s/<c-r><c-w>//gc<Left><Left><Left>")
map("n", "<leader>t", ":NvimTreeFindFileToggle<CR>") --open file explorer at current file
-- map("n", "<leader>t", ":NvimTreeToggle<CR>") --open file explorer
map("n", "<leader>p", switch_theme) --cycle themes
map("n", "<leader>P", ":PlugInstall<CR>") --vim-plug
map('n', '<leader>z', ":lua require('FTerm').open()<CR>") --open term
map('t', '<Esc>', '<C-\\><C-n><CMD>lua require("FTerm").close()<CR>') --preserves session
map("n", "<leader>w", ":w<CR>") --write but one less key
map("n", "<leader>d", ":w ") --duplicate to new name
map("n", "<leader>x", "<cmd>!chmod +x %<CR>") --make a file executable
map("n", "<leader>mv", ":!mv % ") --move a file to a new dir
map("n", "<leader>R", ":so %<CR>") --reload neovim config
map("n", "<leader>u", ':silent !xdg-open "<cWORD>" &<CR>') --open a url under cursor
map("v", "<leader>i", "=gv") --auto indent
map("n", "<leader>W", ":set wrap!<CR>") --toggle wrap
map("n", "<leader>l", ":Twilight<CR>") --surrounding dim

-- decisive csv
map("n", "<leader>csa", ":lua require('decisive').align_csv({})<cr>")
map("n", "<leader>csA", ":lua require('decisive').align_csv_clear({})<cr>")
map("n", "[c", ":lua require('decisive').align_csv_prev_col()<cr>")
map("n", "]c", ":lua require('decisive').align_csv_next_col()<cr>")


map("n", "<leader>H", function() --toggle btop in term
    _G.btop:toggle()
end)


map("n", "<leader>ma", function() --quick make in dir of buffer
	local bufdir = vim.fn.expand("%:p:h")
	vim.cmd("lcd " .. bufdir)
	vim.cmd("!sudo make uninstall && sudo make clean install %")
end)


map("n", "<leader>nn", function() --toggle relative vs absolute line numbers
	if vim.wo.relativenumber then
		vim.wo.relativenumber = false
		vim.wo.number = true
	else
		vim.wo.relativenumber = true
	end
end)

-- git
map("n", "<leader>lg", function() Snacks.lazygit() end)

local gitsigns = require('gitsigns')
map('n', ']c', function()
      if vim.wo.diff then
        vim.cmd.normal({']c', bang = true})
      else
        gitsigns.nav_hunk('next')
      end
end)
map('n', '[c', function()
      if vim.wo.diff then
        vim.cmd.normal({'[c', bang = true})
      else
        gitsigns.nav_hunk('prev')
      end
end)
map('n', '<leader>hs', gitsigns.stage_hunk)
map('n', '<leader>hr', gitsigns.reset_hunk)

map('v', '<leader>hs', function()
  gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
end)

map('v', '<leader>hr', function()
  gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
end)

map('n', '<leader>hS', gitsigns.stage_buffer)
map('n', '<leader>hR', gitsigns.reset_buffer)
map('n', '<leader>hp', gitsigns.preview_hunk)
map('n', '<leader>hi', gitsigns.preview_hunk_inline)

map('n', '<leader>hb', function()
  gitsigns.blame_line({ full = true })
end)

map('n', '<leader>hd', gitsigns.diffthis)

map('n', '<leader>hD', function()
  gitsigns.diffthis('~')
end)

map('n', '<leader>hQ', function() gitsigns.setqflist('all') end)
map('n', '<leader>hq', gitsigns.setqflist)

-- Gitsigns Toggles
map('n', '<leader>tb', gitsigns.toggle_current_line_blame)
map('n', '<leader>tw', gitsigns.toggle_word_diff)


-- sshfs
map('n', '<leader>rc', function() require('remote-sshfs.api').connect() end)
map('n', '<leader>rd', function() require('remote-sshfs.api').disconnect() end)
