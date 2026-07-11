# neo-ds

`neo-ds` is a semantic colorscheme framework for Neovim. Themes provide concrete colors while editor and plugin integrations consume stable design-system roles.

> [!CAUTION]
> This repository is 100% vibe-coded. No human has ever read a single line of this code. My sincere apologies to all Lua and Neovim enthusiasts who find the solutions in this repository insulting to their taste.

The data flow is:

```text
primitives -> semantic palette -> roles -> highlight integrations
```

Theme integrations never depend on a concrete primitive such as `primitive.blue.60`. They use roles such as `popup`, `interaction.match`, `diagnostic.error`, and `git.added`, allowing the same integration to work with every light and dark theme.

Concrete themes must be created with `require("neo-ds.theme").define({...})`. The constructor provides an exact `NeoDs.Theme` LuaLS contract and rejects unknown fields, malformed palette branches, role overrides, and direct highlight overrides at runtime.

## Requirements

- Neovim 0.10 or newer
- `termguicolors` support

## Setup

Install with your preferred plugin manager. With lazy.nvim:

```lua
{
  "mrvanish97/neo-ds",
  lazy = false,
  priority = 1000,
  config = function()
    require("neo-ds").setup({})
  end,
}
```

Configure optional overrides before loading a colorscheme:

```lua
require("neo-ds").setup({
  integrations = {
    community = true,
    snacks = true,
  },
  palette = {
    -- accent = { primary = "#0f62fe" },
  },
  roles = {
    -- ["entity.directory"] = { fg = "accent.primary", style = "bold" },
  },
  highlights = {
    -- MyHighlight = "interaction.match",
  },
})

```

`neo-ds` is a framework, not a colorscheme, and intentionally bundles no concrete themes. Install a compatible theme separately and load its colorscheme after calling `setup()`.

Use `:NeoDsReload` after changing setup options, and `:checkhealth neo-ds` to check the framework and its integrations.

When `nvim-colorizer.lua` is installed, its custom parser can color semantic and primitive references such as `accent.primary` and `primitive.neutral.0`. The parser calls `neo-ds.get()` directly, so visualization uses the same alias resolution and validation as theme compilation.

## Integrations

Integrations are enabled by default and can be disabled independently:

```lua
require("neo-ds").setup({
  integrations = {
    snacks = false,
  },
})
```

The `snacks` integration covers shared windows, picker/explorer, dashboard, input, notifier, indent/scope, scratch, and zen UI. It only declares highlight groups; Snacks does not need to be installed for the theme to compile.

The `community` integration currently contains the legacy mappings for Telescope, Neo-tree, Oil, Diffview, nvim-cmp, Mason, lazy.nvim, DAP UI, Barbecue, Navic, and related plugins. These mappings can be extracted into individual modules without changing the compiler or public configuration shape.

## Writing an integration

An integration returns raw highlight mappings expressed through roles and semantic tokens:

```lua
local M = {}

function M.groups()
  return {
    ExampleNormal = "popup",
    ExampleBorder = "float.border",
    ExampleMatch = "interaction.match",
    ExampleError = "diagnostic.error",
  }
end

return M
```

Register the module in `lua/neo-ds/integrations/init.lua` and add its default to `default_config.integrations`.

## Validation

From the Neovim configuration directory:

```sh
nvim --headless -u NONE -l scripts/neo-ds-smoke.lua
nvim --headless -u NONE -l scripts/neo-ds-highlight-report.lua
```

The smoke test compiles and reloads a private test fixture, verifies integration controls and representative Snacks highlights, and ensures an invalid configuration cannot clear the active colorscheme.
