---@type NeoDs.Theme
local theme = {
  name = "neo-ds-test",
  background = "light",
  primitives = {
    white = "#ffffff",
    black = "#000000",
    gray = "#666666",
    blue = "#005faf",
    purple = "#875fdf",
    violet = "#5f00af",
    cyan = "#008787",
    green = "#008700",
    red = "#af0000",
    yellow = "#af8700",
  },
  ---@type NeoDs.ThemePalette
  palette = {
    background = {
      primary = "primitive.white",
      secondary = "primitive.white",
      tertiary = "primitive.white",
      quaternary = "primitive.gray",
    },
    foreground = {
      primary = "primitive.black",
      secondary = "primitive.gray",
      muted = "primitive.gray",
      inverse = "primitive.white",
    },
    accent = {
      primary = "primitive.blue",
      secondary = "primitive.purple",
      tertiary = "primitive.violet",
      quaternary = "primitive.cyan",
      literal = "primitive.blue",
      note = "primitive.yellow",
    },
    feedback = {
      success = "primitive.green",
      danger = "primitive.red",
    },
    syntax = {
      keyword = {
        primary = "primitive.purple",
        secondary = "primitive.black",
        directive = "primitive.yellow",
      },
      type = { _ = "primitive.cyan" },
      ["function"] = { _ = "primitive.violet" },
      constant = "primitive.blue",
      string = "primitive.red",
      operator = "primitive.gray",
      punctuation = "primitive.black",
    },
  },
}

return require("neo-ds.theme").define(theme)
