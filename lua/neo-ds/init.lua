local compiler = require("neo-ds.compiler")

local M = {}

local adapter_names = {
  "core",
  "syntax",
  "treesitter",
  "lsp",
  "integrations",
}

local default_config = {
  background = "light",
  primitives = {},
  palette = require("neo-ds.palette"),
  roles = require("neo-ds.roles"),
  integrations = {
    community = true,
    snacks = true,
  },
  highlights = {},
}

local user_config = {}

local state = vim.deepcopy(default_config)

local function merge_config(opts)
  return vim.tbl_deep_extend("force", vim.deepcopy(default_config), opts or {})
end

local function collect_highlights(config)
  local groups = {}

  for _, name in ipairs(adapter_names) do
    local adapter = require("neo-ds.adapters." .. name)
    groups = vim.tbl_deep_extend("force", groups, adapter(config))
  end

  return vim.tbl_deep_extend("force", groups, config.highlights or {})
end

local function compile_highlights(config)
  return compiler.compile_groups(collect_highlights(config), config)
end

local function apply_highlights(highlights)
  for group, hl in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, hl)
  end
end

function M.setup(opts)
  user_config = vim.deepcopy(opts or {})
  state = merge_config(user_config)
  return state
end

function M.config(opts)
  if opts then
    return merge_config(opts)
  end
  return state
end

function M.get(name, opts)
  local config = opts and merge_config(opts) or state
  return compiler.resolve_token(name, config, "get(" .. name .. ")")
end

function M.role(name, opts)
  local config = opts and merge_config(opts) or state
  return compiler.resolve_role(name, config)
end

function M.highlights(opts)
  local config = opts and merge_config(opts) or state
  return compile_highlights(config)
end

function M.apply(opts)
  local config = merge_config(opts)
  local highlights = compile_highlights(config)

  state = config
  apply_highlights(highlights)
end

function M.load(opts)
  local config = merge_config(vim.tbl_deep_extend("force", vim.deepcopy(opts or {}), user_config))
  local highlights = compile_highlights(config)

  vim.opt.termguicolors = true
  vim.opt.background = config.background
  vim.cmd("hi clear")
  if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
  end
  vim.g.colors_name = config.name or "neo-ds"

  state = config
  apply_highlights(highlights)
end

function M.reload()
  local colorscheme = vim.g.colors_name
  if not colorscheme or colorscheme == "" then
    error("neo-ds cannot reload before a colorscheme has been loaded")
  end

  vim.cmd.colorscheme(colorscheme)
end

pcall(vim.api.nvim_del_user_command, "NeoDsReload")
vim.api.nvim_create_user_command("NeoDsReload", function()
  M.reload()
end, {})

return M
