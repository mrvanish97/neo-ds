# neo-ds - Neovim Design System

> [!CAUTION]
> This repository, including both code and documentation, is 100% vibe-coded. No human has ever read a single line of this code. My sincere apologies to all Lua and Neovim enthusiasts who find the solutions in this repository insulting to their taste.

`neo-ds` stands for **Neovim Design System**.

Neovim themes usually wire colors directly to highlight groups: `Normal`, `CursorLine`, `DiagnosticError`, `SnacksPickerMatch`, `TelescopeSelection`, Tree-sitter captures, and hundreds of other names owned by different parts of the editor and plugin ecosystem.

That works, but it does not scale well. The same visual decision gets repeated in many places, and each integration has to decide for itself what a match, border, selected item, warning, reference, or inactive surface should look like.

`neo-ds` exists to put a semantic mapping layer between meaning and colorization.

Instead of every integration picking concrete colors, integrations describe what something means:

```text
popup
float.border
interaction.match
diagnostic.error
git.added
entity.directory
syntax.keyword.primary
```

Concrete themes provide color palettes. `neo-ds` maps those semantic roles to Neovim highlight groups.

The data flow is:

```text
primitives -> semantic palette -> roles -> highlight integrations
```

This gives theme authors one place to define the visual system, and integration authors one stable vocabulary to target. A picker match, a search result, a diagnostic, and a Git diff can stay visually consistent without every plugin mapping knowing the exact hex colors.

## What This Is

`neo-ds` is a framework, not a colorscheme.

It intentionally does not ship a concrete theme. It provides:

- a typed concrete theme contract
- palette reference validation
- semantic role compilation
- Neovim highlight generation
- editor, Tree-sitter, LSP, and plugin integrations
- optional visualization of palette references through `nvim-colorizer.lua`

Concrete themes must be created with `require("neo-ds.theme").define({...})`. The constructor provides a `NeoDs.Theme` LuaLS contract and rejects unknown fields, malformed palette branches, role overrides, and direct highlight overrides at runtime.

## Theme Examples

- [ycode-nvim-theme](https://github.com/mrvanish97/ycode-nvim-theme) - a thin concrete theme package built on top of `neo-ds`

## Requirements

- Neovim 0.10 or newer
- `termguicolors` support

## Setup

Install `neo-ds` first, then install a compatible theme.

With lazy.nvim:

```lua
{
  "mrvanish97/neo-ds",
  lazy = false,
  priority = 1000,
  config = function()
    require("neo-ds").setup({})
  end,
},
{
  "mrvanish97/ycode-nvim-theme",
  lazy = false,
  priority = 999,
  dependencies = { "mrvanish97/neo-ds" },
  config = function()
    vim.opt.background = "light"
    vim.cmd.colorscheme("ycode-owned-light")
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

The `community` integration currently contains mappings for Telescope, Neo-tree, Oil, Diffview, nvim-cmp, Mason, lazy.nvim, DAP UI, Barbecue, Navic, and related plugins. These mappings can be extracted into individual modules without changing the compiler or public configuration shape.

## Writing an Integration

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

From the repository root:

```sh
nvim --headless -u NONE -l scripts/neo-ds-smoke.lua
nvim --headless -u NONE -l scripts/neo-ds-highlight-report.lua
git diff --check
```

The smoke test compiles and reloads a private test fixture, verifies integration controls and representative Snacks highlights, and ensures an invalid configuration cannot clear the active colorscheme.
