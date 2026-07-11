local M = {}

function M.check()
  vim.health.start("neo-ds")

  if vim.fn.has("nvim-0.10") == 1 then
    vim.health.ok("Neovim 0.10 or newer")
  else
    vim.health.error("neo-ds requires Neovim 0.10 or newer")
  end

  for _, name in ipairs({ "community", "snacks" }) do
    local ok = pcall(require, "neo-ds.integrations." .. name)
    if ok then
      vim.health.ok("integration available: " .. name)
    else
      vim.health.error("integration failed to load: " .. name)
    end
  end
end

return M
