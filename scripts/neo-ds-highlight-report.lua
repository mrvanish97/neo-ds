local root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h:h")
vim.opt.runtimepath:prepend(root)
local data_dir = root .. "/testdata/neo-ds"

vim.opt.swapfile = false
require("neo-ds").load(dofile(data_dir .. "/theme.lua"))
print("THEME neo-ds-test")

local roles = {
  primary = "@keyword.return",
  secondary = "@keyword.import",
  directive = "@keyword.directive",
  operator = "@operator",
  type = "@type",
  call = "@function.method.call",
  func = "@function",
  literal = "@constant",
  string = "@string",
}

local role_order = {
  "primary",
  "secondary",
  "directive",
  "operator",
  "type",
  "call",
  "func",
  "literal",
  "string",
}

local function hl_for(group)
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
  if not ok then
    return {}
  end
  return hl
end

local role_hl = {}
for _, role in ipairs(role_order) do
  local group = roles[role]
  role_hl[role] = hl_for(group)
end

local function same_hl(a, b)
  return a.fg == b.fg
    and a.bg == b.bg
    and a.bold == b.bold
    and a.italic == b.italic
    and a.underline == b.underline
    and a.strikethrough == b.strikethrough
end

local function role_for_hl(hl)
  for _, role in ipairs(role_order) do
    local expected = role_hl[role]
    if same_hl(hl, expected) then
      return role
    end
  end
  return "unmatched"
end

local function fallback_groups(group)
  local groups = { group }
  local capture, lang = group:match("^(@.+)%.([%w_]+)$")
  while capture and lang do
    table.insert(groups, capture)
    capture, lang = capture:match("^(@.+)%.([%w_]+)$")
  end
  if group:match("^@keyword") then
    table.insert(groups, "@keyword")
  end
  table.insert(groups, "Normal")
  return groups
end

local function resolved_group_hl(group)
  for _, candidate in ipairs(fallback_groups(group)) do
    local hl = hl_for(candidate)
    if next(hl) ~= nil then
      return candidate, hl
    end
  end
  return "Normal", hl_for("Normal")
end

local function color(value)
  if not value then
    return "none"
  end
  return string.format("#%06x", value)
end

local function find_token(buf, needle, occurrence)
  occurrence = occurrence or 1
  local seen = 0
  for row, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
    local start = 1
    while true do
      local from = line:find(needle, start, true)
      if not from then
        break
      end
      seen = seen + 1
      if seen == occurrence then
        return row - 1, from - 1
      end
      start = from + #needle
    end
  end
  error(("token %q occurrence %d not found"):format(needle, occurrence))
end

local function captures_at(buf, lang, row, col)
  local parser = vim.treesitter.get_parser(buf, lang)
  local tree = parser:parse()[1]
  local query = vim.treesitter.query.get(lang, "highlights")
  local out = {}
  if not query then
    return out
  end

  for id, node in query:iter_captures(tree:root(), buf, row, row + 1) do
    local sr, sc, er, ec = node:range()
    local contains = (row > sr or (row == sr and col >= sc)) and (row < er or (row == er and col < ec))
    if contains then
      local capture = query.captures[id]
      table.insert(out, {
        capture = capture,
        group = "@" .. capture .. "." .. lang,
      })
    end
  end

  return out
end

local cases = {
  {
    file = "sample.py",
    lang = "python",
    tokens = {
      { "import", "secondary" },
      { "from", "secondary" },
      { "def", "primary" },
      { "if", "primary" },
      { "is", "secondary" },
      { "not", "secondary" },
      { "return", "primary" },
      { "raise", "primary" },
      { "async", "secondary" },
      { "await", "secondary" },
      { "set", "call", 2 },
      { "print", "call" },
      { "len", "call" },
    },
  },
  {
    file = "sample.ts",
    lang = "typescript",
    tokens = {
      { "import", "secondary" },
      { "export", "secondary" },
      { "abstract", "secondary" },
      { "class", "primary" },
      { "public", "secondary" },
      { "static", "secondary" },
      { "readonly", "secondary" },
      { "async", "secondary" },
      { "if", "primary" },
      { "instanceof", "secondary" },
      { "return", "primary" },
      { "throw", "primary" },
      { "new", "secondary" },
    },
  },
  {
    file = "Sample.java",
    lang = "java",
    tokens = {
      { "package", "secondary" },
      { "import", "secondary" },
      { "public", "secondary" },
      { "final", "secondary" },
      { "class", "primary" },
      { "private", "secondary" },
      { "static", "secondary" },
      { "if", "primary" },
      { "instanceof", "secondary" },
      { "return", "primary" },
      { "throw", "primary" },
      { "new", "secondary" },
    },
  },
  {
    file = "sample.go",
    lang = "go",
    tokens = {
      { "package", "primary" },
      { "import", "primary" },
      { "const", "primary" },
      { "var", "primary" },
      { "make", "call" },
      { "chan", "primary" },
      { "int", "primary" },
      { "type", "primary" },
      { "interface", "primary" },
      { "byte", "primary" },
      { "error", "primary" },
      { "struct", "primary" },
      { "string", "primary" },
      { "func", "primary" },
      { "defer", "primary" },
      { "go", "primary" },
      { "len", "call" },
      { "select", "primary" },
      { "case", "primary" },
      { ":=", "operator" },
      { "<-", "operator" },
      { "switch", "primary" },
      { "type", "primary", 2 },
      { "for", "primary" },
      { "range", "primary" },
      { "if", "primary" },
      { ">", "operator" },
      { "continue", "primary" },
      { "else", "primary" },
      { "break", "primary" },
      { "fallthrough", "primary" },
      { "default", "primary" },
      { "return", "primary" },
    },
  },
  {
    file = "sample.lua",
    lang = "lua",
    tokens = {
      { "local", "secondary" },
      { "function", "primary" },
      { "if", "primary" },
      { "not", "secondary" },
      { "return", "primary" },
      { "or", "secondary" },
    },
  },
  {
    file = "sample.sh",
    lang = "bash",
    tokens = {
      { "readonly", "secondary" },
      { "if", "primary" },
      { "-n", "secondary" },
      { "then", "primary" },
      { "else", "primary" },
      { "fi", "primary" },
    },
  },
  {
    file = "sample.css",
    lang = "css",
    tokens = {
      { "@media", "directive" },
      { "and", "secondary" },
    },
  },
  {
    file = "sample.vim",
    lang = "vim",
    tokens = {
      { "function", "primary" },
      { "if", "primary" },
      { "isnot", "secondary" },
      { "return", "primary" },
      { "endif", "primary" },
      { "endfunction", "primary" },
    },
  },
}

local failures = {}

for _, case in ipairs(cases) do
  local path = data_dir .. "/" .. case.file
  vim.cmd.edit(vim.fn.fnameescape(path))
  local buf = vim.api.nvim_get_current_buf()

  print(("FILE %s (%s)"):format(case.file, case.lang))
  for _, token in ipairs(case.tokens) do
    local needle, expected, occurrence = token[1], token[2], token[3]
    local row, col = find_token(buf, needle, occurrence)
    local captures = captures_at(buf, case.lang, row, col)
    local actual = "unmatched"
    local group = "Normal"
    local hl = hl_for(group)
    local group_names = {}

    for _, item in ipairs(captures) do
      table.insert(group_names, item.group)
      local resolved_group, candidate_hl = resolved_group_hl(item.group)
      local candidate_role = role_for_hl(candidate_hl)
      if candidate_role == expected then
        actual = candidate_role
        group = resolved_group
        hl = candidate_hl
        break
      end
      if actual == "unmatched" and candidate_role ~= "unmatched" then
        actual = candidate_role
        group = resolved_group
        hl = candidate_hl
      end
    end

    local status = actual == expected and "ok" or "FAIL"
    print(("%-4s %-12s expected=%-9s actual=%-9s group=%-32s fg=%s bold=%s captures=%s"):format(
      status,
      needle,
      expected,
      actual,
      group,
      color(hl.fg),
      tostring(hl.bold == true),
      table.concat(group_names, ",")
    ))
    if status == "FAIL" then
      table.insert(failures, ("%s:%s expected %s got %s via %s"):format(case.file, needle, expected, actual, group))
    end
  end
end

if #failures > 0 then
  print("FAILURES")
  for _, failure in ipairs(failures) do
    print(failure)
  end
  vim.cmd("cquit 1")
end

vim.cmd("qall!")
