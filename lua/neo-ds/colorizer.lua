local M = {}

local function is_reference_char(byte)
  return byte
    and (byte == 45 or byte == 46 or byte == 95 or (byte >= 48 and byte <= 57) or (byte >= 65 and byte <= 90) or (byte >= 97 and byte <= 122))
end

---@param ctx colorizer.ParserContext
---@return number? length
---@return string? rgb_hex
local function parse(ctx)
  if ctx.col > 1 and is_reference_char(ctx.line:byte(ctx.col - 1)) then
    return
  end

  local candidate = ctx.line:sub(ctx.col):match("^([%a_][%w_-]*%.[%w_.-]+)")
  if not candidate then
    return
  end

  local next_byte = ctx.line:byte(ctx.col + #candidate)
  if is_reference_char(next_byte) then
    return
  end

  -- `get` delegates to compiler.resolve_token, so aliases, parent fallbacks,
  -- primitives, and cycle detection have exactly one implementation.
  local ok, color = pcall(require("neo-ds").get, candidate)
  if not ok or type(color) ~= "string" or not color:match("^#%x%x%x%x%x%x$") then
    return
  end

  return #candidate, color:sub(2):lower()
end

---@return colorizer.CustomParserDef
function M.parser()
  return {
    name = "neo_ds_reference",
    parse = parse,
  }
end

return M
