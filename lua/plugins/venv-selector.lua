require("venv-selector").setup({
  on_venv_activate_callback = nil,

  enable_default_searches = true,

  enable_cached_venvs = true,

  cached_venv_automatic_activation = true,

  activate_venv_in_terminal = true,

  set_environment_variables = true,

  notify_user_on_venv_activation = false,

  override_notify = true,

  search_timeout = 5,

  log_level = "NONE",
  
  fd_binary_name = nil,

  require_lsp_activation = true,

  shell = { shell = vim.o.shell, shellcmdflag = vim.o.shellcmdflag },

  on_telescope_result_callback = nil,

  picker_filter_type = "substring",

  selected_venv_marker_color = "#00FF00",

  selected_venv_marker_icon = "✔",

  picker_icons = {},

  picker_columns = { "marker", "search_icon", "search_name", "search_result" },

  picker_options = {},

  picker = "auto",

  statusline_func = { nvchad = nil, lualine = nil },
})
