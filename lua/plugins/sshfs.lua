-- Mount a server as a Windows drive with SSHFS-Win (choco install winfsp sshfs).
-- Commands: :SshfsConnect :SshfsDisconnect :SshfsStatus. Hosts come from ~/.ssh/config.

local M = {}

local home = vim.env.USERPROFILE or vim.fn.expand("~")

M.config = {
	drive = "S:",
	ssh_config = vim.fs.joinpath(home, ".ssh", "config"),
	key_file = vim.fs.joinpath(home, ".ssh", "id_rsa"), -- the only key SSHFS-Win reads
	change_dir = true,
	unmount_on_exit = true,
}

local state = {
	host = nil,
	unc = nil,
	prev_cwd = nil,
}

local function parse_ssh_config(path)
	local hosts = {}
	local file = io.open(path, "r")
	if not file then
		return hosts
	end

	local current = nil
	for raw in file:lines() do
		local line = raw:gsub("#.*$", ""):match("^%s*(.-)%s*$")
		local key, value = line:match("^(%w+)%s*=?%s*(.-)$")
		if key and value ~= "" then
			key = key:lower()
			if key == "host" then
				current = nil
				for alias in value:gmatch("%S+") do
					if not alias:find("[%*%?!]") then
						current = { name = alias, hostname = alias }
						table.insert(hosts, current)
						break
					end
				end
			elseif key == "match" then
				current = nil
			elseif current then
				if key == "hostname" then
					current.hostname = value
				elseif key == "user" then
					current.user = value
				elseif key == "port" then
					current.port = value
				end
			end
		end
	end
	file:close()
	return hosts
end

-- \\sshfs[.k][r]\USER@HOST[!PORT][\PATH]  (k = key %USERPROFILE%\.ssh\id_rsa, r = path from /)
local function build_unc(host, user, remote_path, use_key)
	local from_root = remote_path:sub(1, 1) == "/"
	local suffix = (use_key and "k" or "") .. (from_root and "r" or "")
	local prefix = suffix == "" and "sshfs" or ("sshfs." .. suffix)

	local target = user .. "@" .. host.hostname
	if host.port and host.port ~= "22" then
		target = target .. "!" .. host.port
	end

	local path = remote_path:gsub("^~/?", ""):gsub("^/+", ""):gsub("/+$", ""):gsub("/", "\\")
	local unc = "\\\\" .. prefix .. "\\" .. target
	if path ~= "" then
		unc = unc .. "\\" .. path
	end
	return unc
end

local function notify(msg, level)
	vim.notify(msg, level or vim.log.levels.INFO, { title = "sshfs" })
end

local function output_of(res)
	return vim.trim((res.stderr or "") .. "\n" .. (res.stdout or ""))
end

local function mount(host, user, remote_path)
	local use_key = vim.uv.fs_stat(M.config.key_file) ~= nil
	local unc = build_unc(host, user, remote_path, use_key)
	local cmd = { "net", "use", M.config.drive, unc }

	if not use_key then
		-- No id_rsa: SSHFS-Win needs the password. It goes to `net use` as an argument,
		-- so it is briefly visible to other processes of your own user.
		local password = vim.fn.inputsecret("Password for " .. user .. "@" .. host.hostname .. ": ")
		if password == "" then
			notify("Cancelled", vim.log.levels.WARN)
			return
		end
		vim.list_extend(cmd, { password, "/user:" .. user })
	end
	table.insert(cmd, "/persistent:no")

	notify("Connecting to " .. host.name .. " (" .. unc .. ")...")
	vim.system(cmd, { text = true }, vim.schedule_wrap(function(res)
		if res.code ~= 0 then
			notify("net use failed:\n" .. output_of(res), vim.log.levels.ERROR)
			return
		end
		state.host, state.unc = host, unc
		if M.config.change_dir then
			state.prev_cwd = vim.uv.cwd()
			vim.cmd.cd(M.config.drive .. "/")
		end
		notify("Mounted " .. unc .. " on " .. M.config.drive)
	end))
end

function M.connect()
	if state.host then
		notify("Already connected to " .. state.host.name .. ". Run :SshfsDisconnect first.", vim.log.levels.WARN)
		return
	end
	local hosts = parse_ssh_config(M.config.ssh_config)
	if #hosts == 0 then
		notify("No hosts found in " .. M.config.ssh_config, vim.log.levels.ERROR)
		return
	end

	vim.ui.select(hosts, {
		prompt = "SSHFS host",
		format_item = function(h)
			return h.name .. "  (" .. (h.user and (h.user .. "@") or "") .. h.hostname .. ")"
		end,
	}, function(host)
		if not host then
			return
		end
		-- SSHFS-Win needs the remote user in the UNC path
		local user = host.user or vim.fn.input("Remote user: ", vim.env.USERNAME or "")
		if user == "" then
			return
		end
		vim.ui.input({
			prompt = "Remote folder (empty = home, /abs/path = from root): ",
		}, function(remote_path)
			if remote_path == nil then
				return
			end
			mount(host, user, vim.trim(remote_path))
		end)
	end)
end

function M.disconnect(opts)
	opts = opts or {}
	local drive = M.config.drive:upper()

	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		local name = vim.api.nvim_buf_get_name(buf):upper()
		if vim.bo[buf].modified and name:sub(1, #drive) == drive then
			notify("Unsaved buffer on " .. drive .. ": " .. name, vim.log.levels.ERROR)
			return
		end
	end

	-- leave the drive first, otherwise Windows reports it as "in use"
	local cwd = (vim.uv.cwd() or ""):upper()
	if cwd:sub(1, #drive) == drive then
		vim.cmd.cd(state.prev_cwd or home)
	end

	local cmd = { "net", "use", M.config.drive, "/delete", "/y" }
	local function done(res)
		if res.code ~= 0 then
			notify("net use /delete failed:\n" .. output_of(res), vim.log.levels.ERROR)
			return
		end
		notify("Disconnected " .. M.config.drive)
		state.host, state.unc, state.prev_cwd = nil, nil, nil
	end

	if opts.sync then
		done(vim.system(cmd, { text = true }):wait(10000))
	else
		vim.system(cmd, { text = true }, vim.schedule_wrap(done))
	end
end

function M.status()
	if state.host then
		notify(state.host.name .. ": " .. state.unc .. " on " .. M.config.drive)
	else
		notify("Not connected")
	end
end

function M.statusline()
	return state.host and ("󰒋 " .. state.host.name) or ""
end

M._internal = { parse_ssh_config = parse_ssh_config, build_unc = build_unc }

vim.api.nvim_create_user_command("SshfsConnect", M.connect, { desc = "Mount a server with SSHFS-Win" })
vim.api.nvim_create_user_command("SshfsDisconnect", function()
	M.disconnect()
end, { desc = "Unmount the SSHFS-Win drive" })
vim.api.nvim_create_user_command("SshfsStatus", M.status, { desc = "Show the SSHFS-Win connection" })

vim.api.nvim_create_autocmd("VimLeavePre", {
	group = vim.api.nvim_create_augroup("user_sshfs", { clear = true }),
	callback = function()
		if M.config.unmount_on_exit and state.host then
			M.disconnect({ sync = true })
		end
	end,
})

return M
