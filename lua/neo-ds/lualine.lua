local ds = require("neo-ds")

local M = {}

local function gui(role)
  local hl = ds.role(role)
  local flags = {}
  for _, key in ipairs({ "bold", "italic", "underline", "strikethrough" }) do
    if hl[key] then
      flags[#flags + 1] = key
    end
  end
  return #flags > 0 and table.concat(flags, ",") or nil
end

function M.color(opts)
  opts = opts or {}
  local result = {}

  if opts.fg then
    result.fg = ds.get(opts.fg)
  end
  if opts.bg then
    result.bg = ds.get(opts.bg)
  end
  if opts.gui then
    result.gui = opts.gui
  elseif opts.role then
    result.gui = gui(opts.role)
  end

  return result
end

M.palette = M.color

function M.role(role, patch)
  local hl = ds.role(role)
  local color = {
    fg = hl.fg,
    bg = hl.bg,
    gui = gui(role),
  }
  return vim.tbl_deep_extend("force", color, patch or {})
end

function M.theme()
  return {
    normal = {
      a = M.role("chrome.mode.normal"),
      b = M.color({ fg = "foreground.primary", bg = "background.secondary" }),
      c = M.color({ fg = "foreground.secondary", bg = "background.secondary" }),
    },
    insert = {
      a = M.role("chrome.mode.insert"),
      b = M.color({ fg = "foreground.primary", bg = "background.secondary" }),
      c = M.color({ fg = "foreground.secondary", bg = "background.secondary" }),
    },
    visual = {
      a = M.role("chrome.mode.visual"),
      b = M.color({ fg = "foreground.primary", bg = "background.secondary" }),
      c = M.color({ fg = "foreground.secondary", bg = "background.secondary" }),
    },
    replace = {
      a = M.role("chrome.mode.replace"),
      b = M.color({ fg = "foreground.primary", bg = "background.secondary" }),
      c = M.color({ fg = "foreground.secondary", bg = "background.secondary" }),
    },
    command = {
      a = M.role("chrome.mode.command"),
      b = M.color({ fg = "foreground.primary", bg = "background.secondary" }),
      c = M.color({ fg = "foreground.secondary", bg = "background.secondary" }),
    },
    inactive = {
      a = M.color({ fg = "foreground.muted", bg = "background.secondary", gui = "bold" }),
      b = M.color({ fg = "foreground.muted", bg = "background.secondary" }),
      c = M.color({ fg = "foreground.muted", bg = "background.secondary" }),
    },
  }
end

return M
