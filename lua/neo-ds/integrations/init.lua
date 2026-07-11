local M = {}

local integration_names = {
  "community",
  "snacks",
}

local function enabled(config, name)
  local integrations = config.integrations or {}
  return integrations[name] ~= false
end

function M.collect(config)
  local groups = {}

  for _, name in ipairs(integration_names) do
    if enabled(config, name) then
      local integration = require("neo-ds.integrations." .. name)
      groups = vim.tbl_deep_extend("force", groups, integration.groups(config))
    end
  end

  return groups
end

return M
