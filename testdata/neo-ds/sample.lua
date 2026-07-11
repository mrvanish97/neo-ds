local M = {}

function M.check(value)
  if value ~= nil and not false then
    return true
  end
  return value or false
end

return M
