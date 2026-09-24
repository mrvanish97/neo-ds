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

local incomplete = vim.deepcopy(fixture)
incomplete.palette.syntax.string = nil
local ok_incomplete, incomplete_error = pcall(theme_contract.define, incomplete)
assert_equal(false, ok_incomplete, "theme contract accepted an incomplete semantic palette")
assert(incomplete_error:find("palette.syntax.string is required", 1, true), incomplete_error)

local missing_child = vim.deepcopy(fixture)
missing_child.palette.syntax["function"].call = nil
local ok_fallback, fallback_error = pcall(ds.get, "syntax.function.call", missing_child)
assert_equal(false, ok_fallback, "compiler fell back from a missing child token to its parent")
assert(fallback_error:find('palette color "syntax.function.call"', 1, true), fallback_error)

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
assert_equal(nil, highlight("Whitespace").bg, "whitespace inherited the editor background")
local snacks_match = highlight("SnacksPickerMatch")
assert_equal(
  ds.role("interaction.match").fg,
  snacks_match.fg and string.format("#%06x", snacks_match.fg),
  "test theme did not use the match role for Snacks"
)
local snacks_indent = highlight("SnacksIndentScope")
assert_equal(
  ds.get("accent.primary"),
  snacks_indent.fg and string.format("#%06x", snacks_indent.fg),
  "test theme did not use the active semantic indent color for Snacks"
)
local snacks_config = require("neo-ds.integrations.snacks").config()
assert_equal(
  ds.get("background.backdrop"),
  snacks_config.zen.win.backdrop.bg,
  "Snacks zen backdrop did not resolve through the semantic palette"
)
assert_equal(50, snacks_config.zen.win.backdrop.blend, "Snacks zen backdrop did not use 50% blending")
assert_equal(false, snacks_config.zen.win.backdrop.transparent, "Snacks zen backdrop dropped its black background")
assert_equal("SnacksIndent", snacks_config.indent.indent.hl, "ordinary indent config used the wrong highlight")
assert_equal("SnacksIndentScope", snacks_config.indent.scope.hl, "active indent config used the wrong highlight")
assert_equal(
  highlight("@type"),
  highlight("@attribute.java"),
  "Java annotation names did not use the regular type highlight"
)
assert_equal(
  highlight("@type"),
  highlight("@lsp.type.annotation"),
  "LSP annotation names did not use the regular type highlight"
)
assert_equal(
  highlight("@keyword"),
  highlight("@type.builtin.java"),
  "Java primitive types did not use the primary keyword highlight"
)
assert_equal(
  highlight("@boolean"),
  highlight("@constant.builtin.java"),
  "Java null did not use the boolean-literal highlight"
)
local annotation_mark = highlight("@punctuation.special.annotation")
assert_equal(
  ds.get("accent.note"),
  annotation_mark.fg and string.format("#%06x", annotation_mark.fg),
  "annotation punctuation did not use the note accent"
)

local without_snacks = ds.highlights(vim.tbl_deep_extend("force", fixture, {
  integrations = { snacks = false },
}))
assert_equal(nil, without_snacks.SnacksPickerNormal, "disabled Snacks integration still emitted groups")

local colorscheme = vim.g.colors_name
local normal = highlight("Normal")
ds.setup({
  highlights = {
    Normal = { fg = "missing.token" },
  },
})
local ok = pcall(ds.load, fixture)

assert_equal(false, ok, "invalid configuration unexpectedly loaded")
assert_equal(colorscheme, vim.g.colors_name, "invalid configuration changed the active colorscheme")
assert_equal(normal, highlight("Normal"), "invalid configuration changed Normal")
ds.setup({})

local bypassed = vim.deepcopy(fixture)
local ok_bypassed, bypassed_error = pcall(ds.load, bypassed)
assert_equal(false, ok_bypassed, "load accepted a theme that bypassed theme.define()")
assert(bypassed_error:find("concrete themes must be created", 1, true), bypassed_error)

print("neo-ds smoke: ok")
