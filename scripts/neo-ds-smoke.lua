local root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h:h")
vim.opt.runtimepath:prepend(root)

local function assert_equal(expected, actual, message)
  if not vim.deep_equal(expected, actual) then
    error(("%s\nexpected: %s\nactual:   %s"):format(message, vim.inspect(expected), vim.inspect(actual)))
  end
end

local function highlight(name)
  return vim.api.nvim_get_hl(0, { name = name, link = false })
end

local ds = require("neo-ds")
local theme_contract = require("neo-ds.theme")
local fixture = dofile(root .. "/testdata/neo-ds/theme.lua")
assert_equal(true, theme_contract.is_defined(fixture), "test theme bypassed theme.define()")
assert_equal(nil, fixture.roles, "concrete theme contains role overrides")
assert_equal(nil, fixture.highlights, "concrete theme contains highlight overrides")

local ok_unknown, unknown_error = pcall(theme_contract.define, {
  name = "invalid",
  background = "light",
  primitives = {},
  palette = { syntax = { punctation = "foreground.primary" } },
})
assert_equal(false, ok_unknown, "theme contract accepted an unknown palette field")
assert(unknown_error:find("palette.syntax.punctation", 1, true), unknown_error)

local ok_override, override_error = pcall(theme_contract.define, {
  name = "invalid",
  background = "light",
  primitives = {},
  palette = {},
  highlights = {},
})
assert_equal(false, ok_override, "theme contract accepted highlight overrides")
assert(override_error:find("highlights", 1, true), override_error)

ds.load(fixture)
local normal = highlight("Normal")
ds.load(fixture)
assert_equal("neo-ds-test", vim.g.colors_name, "theme changed its name during reload")
assert_equal(normal, highlight("Normal"), "theme changed Normal during reload")
local snacks_match = highlight("SnacksPickerMatch")
assert_equal(
  ds.role("interaction.match").fg,
  snacks_match.fg and string.format("#%06x", snacks_match.fg),
  "test theme did not use the match role for Snacks"
)

local without_snacks = ds.highlights(vim.tbl_deep_extend("force", fixture, {
  integrations = { snacks = false },
}))
assert_equal(nil, without_snacks.SnacksPickerNormal, "disabled Snacks integration still emitted groups")

local colorscheme = vim.g.colors_name
local normal = highlight("Normal")
local invalid = vim.tbl_deep_extend("force", fixture, {
  highlights = {
    Normal = { fg = "missing.token" },
  },
})
local ok = pcall(ds.load, invalid)

assert_equal(false, ok, "invalid configuration unexpectedly loaded")
assert_equal(colorscheme, vim.g.colors_name, "invalid configuration changed the active colorscheme")
assert_equal(normal, highlight("Normal"), "invalid configuration changed Normal")

print("neo-ds smoke: ok")
