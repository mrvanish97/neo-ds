local M = {}

---@class Cache
---@field items table<string, integer>
local Cache = {}
Cache.__index = Cache

function Cache.new(items)
  return setmetatable({ items = items or {} }, Cache)
end

function Cache:set(key, value)
  self.items[key] = value
end

function Cache:get(key, default)
  if self.items[key] ~= nil then
    return self.items[key]
  end
  return default or false
end

function M.check(value)
  local cache = Cache.new({ a = 1 })
  cache:set("b", 2)

  if value ~= nil and not false then
    return cache:get("b") .. tostring(value)
  end
  return value or false
end

return M
