local integrations = require("neo-ds.integrations")

return function(config)
  return integrations.collect(config)
end
