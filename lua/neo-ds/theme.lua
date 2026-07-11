local M = {}

local leaf = true
local schema = {
  background = {
    primary = leaf,
    secondary = leaf,
    tertiary = leaf,
    quaternary = leaf,
    cursorline = leaf,
    selection = leaf,
    editor = leaf,
    sidebar = leaf,
    float = leaf,
    popup = { _ = leaf, selected = leaf, scrollbar = leaf, thumb = leaf },
    search = { _ = leaf, active = leaf },
    reference = { _ = leaf, subtle = leaf, write = leaf },
    feedback = { info = leaf, hint = leaf, success = leaf, warning = leaf, danger = leaf },
  },
  foreground = {
    primary = leaf,
    secondary = leaf,
    muted = leaf,
    inverse = leaf,
    disabled = leaf,
    deprecated = leaf,
    link = leaf,
  },
  border = { primary = leaf, secondary = leaf, subtle = leaf, focus = leaf },
  accent = { primary = leaf, secondary = leaf, tertiary = leaf, quaternary = leaf, literal = leaf, note = leaf },
  interaction = { active = leaf, focus = leaf, hover = leaf, selected = leaf, match = leaf },
  feedback = { info = leaf, hint = leaf, success = leaf, warning = leaf, danger = leaf },
  entity = { file = leaf, directory = { _ = leaf, icon = leaf }, link = leaf },
  syntax = {
    comment = leaf,
    keyword = { _ = leaf, primary = leaf, secondary = leaf, directive = leaf },
    annotation = leaf,
    variable = leaf,
    property = leaf,
    constant = leaf,
    string = leaf,
    number = leaf,
    boolean = leaf,
    operator = leaf,
    punctuation = leaf,
    bracket = leaf,
    preprocessor = leaf,
    builtin = leaf,
    tag = leaf,
    type = { _ = leaf, parameter = leaf },
    ["function"] = { _ = leaf, call = leaf, definition = leaf },
    markup = { heading = leaf, raw = leaf },
  },
  vcs = { added = leaf, changed = leaf, deleted = leaf, untracked = leaf },
  chrome = {
    base = leaf,
    inactive = leaf,
    mode = { normal = leaf, insert = leaf, visual = leaf, replace = leaf, command = leaf },
  },
}

local defined = setmetatable({}, { __mode = "k" })

local function fail(name, path, message)
  error(('neo-ds theme %q: %s %s'):format(name or "<unnamed>", path, message), 0)
end

local function validate_palette(node, expected, name, path)
  if type(node) ~= "table" then
    fail(name, path, "must be a keyed table")
  end

  for key, value in pairs(node) do
    if type(key) ~= "string" then
      fail(name, path, "must use string keys")
    end
    local child = expected[key]
    local child_path = path .. "." .. key
    if child == nil then
      fail(name, child_path, "is not part of the palette contract")
    elseif child == leaf then
      if type(value) ~= "string" or value == "" then
        fail(name, child_path, "must be a non-empty color reference")
      end
    else
      validate_palette(value, child, name, child_path)
    end
  end
end

local function validate_primitives(node, name, path)
  if type(node) ~= "table" then
    fail(name, path, "must be a keyed table")
  end
  for key, value in pairs(node) do
    if type(key) ~= "string" or key == "" then
      fail(name, path, "must use non-empty string keys")
    end
    local child_path = path .. "." .. key
    if type(value) == "table" then
      validate_primitives(value, name, child_path)
    elseif type(value) ~= "string" or value == "" then
      fail(name, child_path, "must be a non-empty color reference or primitive table")
    end
  end
end

---@param spec NeoDs.Theme
---@return NeoDs.Theme
function M.define(spec)
  if type(spec) ~= "table" then
    fail(nil, "theme", "must be a keyed table")
  end

  local name = type(spec.name) == "string" and spec.name or nil
  local allowed = { name = true, background = true, primitives = true, palette = true }
  for key in pairs(spec) do
    if not allowed[key] then
      fail(name, tostring(key), "is not part of the concrete theme contract")
    end
  end

  if not name or name == "" then
    fail(name, "name", "must be a non-empty string")
  end
  if spec.background ~= "light" and spec.background ~= "dark" then
    fail(name, "background", 'must be "light" or "dark"')
  end
  if spec.primitives == nil then
    fail(name, "primitives", "is required")
  end
  if spec.palette == nil then
    fail(name, "palette", "is required")
  end

  validate_primitives(spec.primitives, name, "primitives")
  validate_palette(spec.palette, schema, name, "palette")

  local result = vim.deepcopy(spec)
  defined[result] = true
  return result
end

---@param value any
---@return boolean
function M.is_defined(value)
  return defined[value] == true
end

return M
