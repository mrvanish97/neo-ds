> [!CAUTION]
> This repository, including both code and documentation, is 100% vibe-coded. No human has ever read a single line of this code. My sincere apologies to all Lua and Neovim enthusiasts who find the solutions in this repository insulting to their taste.

# neo-ds - Neovim Design System

`neo-ds` stands for **Neovim Design System**.

## Why This Exists

Neovim appearance is hard to tune because colors are usually attached directly to hundreds of unrelated highlight groups: core editor UI, Tree-sitter captures, diagnostics, LSP references, Snacks picker, Telescope, completion menus, file explorers, statuslines, and more.

That means a simple preference like "make matches purple", "make popups less noisy", or "make directory names bold blue" can require hunting through plugin-specific highlight names.

`neo-ds` adds a mapping layer between semantic meaning and colorization. You describe what a thing means once, and `neo-ds` maps that decision to the highlight groups used by Neovim and supported plugins.

For example:

```lua
require("neo-ds").setup({
  palette = {
    accent = {
      primary = "#0f68a0",
      secondary = "#ad3da4",
    },
  },
  roles = {
    ["interaction.match"] = { fg = "accent.secondary", style = "bold" },
    ["entity.directory"] = { fg = "accent.primary", style = "bold" },
    ["float.border"] = { fg = "border.subtle", bg = "background.float" },
  },
})
```

With those few semantic overrides, every integration that uses `interaction.match`, `entity.directory`, or `float.border` follows the same visual decision. You do not need to separately remember how Snacks, Telescope, Neo-tree, completion popups, and built-in search each name their highlights.

Concrete themes provide the base palette. Your config can then adjust semantic roles instead of patching random highlight groups one by one.

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

## How It Works

The internal flow is:

```text
primitives -> semantic palette -> roles -> highlight integrations
```

Integrations should target semantic roles such as `popup`, `interaction.match`, `diagnostic.error`, `git.added`, `entity.directory`, and `syntax.keyword.primary`. They should not depend on concrete primitive colors such as `primitive.blue.60`.

That separation lets the same integration work with different light and dark themes while preserving the theme author's visual intent.

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
