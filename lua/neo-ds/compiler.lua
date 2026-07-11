local M = {}

local style_keys = {
  bold = true,
  italic = true,
  underline = true,
  undercurl = true,
  strikethrough = true,
  reverse = true,
  standout = true,
  nocombine = true,
}

local function copy(value)
  return vim.deepcopy(value)
end

local function split_role(role)
  local parts = {}
  for part in role:gmatch("[^.]+") do
    parts[#parts + 1] = part
  end
  return parts
end

local function merge_role_path(role, roles)
  local parts = split_role(role)
  local merged = {}
  local path = nil

	  for _, part in ipairs(parts) do
	    path = path and (path .. "." .. part) or part
	    if roles[path] then
	      local role_spec = copy(roles[path])
	      if role_spec.inherit == false then
	        merged = {}
	      end
	      role_spec.inherit = nil
	      merged = vim.tbl_deep_extend("force", merged, role_spec)
	    end
	  end

  if vim.tbl_isempty(merged) then
    error(("neo-ds role %q is not defined"):format(role))
  end

  return merged
end

local function resolve_color(value, config, path)
  if value == nil or value == "NONE" or value == "none" then
    return value
  end
  if type(value) ~= "string" then
    return value
  end
  if value:sub(1, 1) == "#" then
    return value
  end
  return M.resolve_token(value, config, path)
end

local function apply_style(hl, style)
  if style == nil then
    return
  end
  if type(style) == "string" then
    hl[style] = true
    return
  end
  if vim.tbl_islist(style) then
    for _, name in ipairs(style) do
      hl[name] = true
    end
    return
  end
  for name, enabled in pairs(style) do
    if style_keys[name] then
      hl[name] = enabled
    end
  end
end

local function palette_direct_lookup(palette, name)
  if palette[name] ~= nil then
    local direct = palette[name]
    if type(direct) == "table" then
      return direct._
    end
    return direct
  end

  local node = palette
  for part in name:gmatch("[^.]+") do
    if type(node) ~= "table" then
      return nil
    end
    node = node[part]
    if node == nil then
      return nil
    end
  end

  if type(node) == "table" then
    return node._
  end
  return node
end

local function palette_parent(name)
  return name:match("^(.*)%.[^.]+$")
end

function M.compile_spec(spec, config, path)
  if spec.link then
    return { link = spec.link }
  end

  local hl = {}
  for _, key in ipairs({ "fg", "bg", "sp" }) do
    if spec[key] ~= nil then
      hl[key] = resolve_color(spec[key], config, path .. "." .. key)
    end
  end

  apply_style(hl, spec.style)
  for key in pairs(style_keys) do
    if spec[key] ~= nil then
      hl[key] = spec[key]
    end
  end

  return hl
end

function M.resolve_token(name, config, path, seen)
  seen = seen or {}
  if seen[name] then
    error(("neo-ds token alias cycle at %q referenced by %s"):format(name, path or "palette"))
  end
  seen[name] = true

  local primitive_name = name:match("^primitive%.(.+)$")
  if primitive_name then
    local primitive = palette_direct_lookup(config.primitives or {}, primitive_name)
    if primitive == nil then
      error(("neo-ds primitive %q referenced by %s is not defined"):format(primitive_name, path or "palette"))
    end
    if type(primitive) == "string" and primitive:sub(1, 1) ~= "#" and primitive ~= "NONE" and primitive ~= "none" then
      return M.resolve_token(primitive, config, path or name, seen)
    end
    return primitive
  end

  local raw = palette_direct_lookup(config.palette, name)
  if raw == nil then
    local parent = palette_parent(name)
    if parent then
      return M.resolve_token(parent, config, path or name, seen)
    end
    error(("neo-ds palette color %q referenced by %s is not defined"):format(name, path or "palette"))
  end

  if type(raw) ~= "string" then
    return raw
  end
  if raw == "NONE" or raw == "none" or raw:sub(1, 1) == "#" then
    return raw
  end

  return M.resolve_token(raw, config, path or name, seen)
end

function M.resolve_role(role, config)
  local spec = merge_role_path(role, config.roles)
  return M.compile_spec(spec, config, "role " .. role)
end

function M.compile_groups(groups, config)
  local compiled = {}

  for group, role_or_spec in pairs(groups) do
    if type(role_or_spec) == "string" then
      compiled[group] = M.resolve_role(role_or_spec, config)
    elseif type(role_or_spec) == "table" and role_or_spec.role then
      local spec = merge_role_path(role_or_spec.role, config.roles)
      local patch = copy(role_or_spec)
      patch.role = nil
      compiled[group] = M.compile_spec(vim.tbl_deep_extend("force", spec, patch), config, "group " .. group)
    elseif type(role_or_spec) == "table" then
      compiled[group] = M.compile_spec(role_or_spec, config, "group " .. group)
    else
      error(("neo-ds group %q has invalid mapping"):format(group))
    end
  end

  return compiled
end

return M
