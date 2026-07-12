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
---@type NeoDs.ThemePalette
local palette = {
  accent = {
    primary = "#0f68a0",
    secondary = "#ad3da4",
  },
}

require("neo-ds").setup({
  palette = palette,
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

Concrete themes must be created with `require("neo-ds.theme").define({...})`. The `NeoDs.Theme` LuaLS contract documents the theme shape, and the constructor rejects unknown fields, malformed palette branches, role overrides, and direct highlight overrides at runtime.

The semantic palette contract is documented in [lua/neo-ds/types.lua](lua/neo-ds/types.lua). Treat that file as the registry for available semantic tokens: it contains the hierarchy, LuaLS types, and short descriptions for every palette field that a concrete theme may define.

## How It Works

The internal flow is:

```text
primitives -> semantic palette -> roles -> highlight integrations
```

Integrations should target semantic roles such as `popup`, `interaction.match`, `diagnostic.error`, `git.added`, `entity.directory`, and `syntax.keyword.primary`. They should not depend on concrete primitive colors such as `primitive.blue.60`.

That separation lets the same integration work with different light and dark themes while preserving the theme author's visual intent.

## Theme Examples

- [ycode-nvim-theme](https://github.com/mrvanish97/ycode-nvim-theme) - a thin concrete theme package built on top of `neo-ds`

## Writing a Theme

Concrete themes should stay palette-only. They define raw primitives, map those primitives into the semantic palette, and let `neo-ds` compile roles and integrations.

Use the LuaLS types from [lua/neo-ds/types.lua](lua/neo-ds/types.lua) when writing theme files. The annotations are not required at runtime; `require("neo-ds.theme").define()` still validates plain Lua tables. They are recommended because they make the semantic token hierarchy discoverable through editor completion and keep theme data aligned with the documented contract.

Create a colorscheme file such as `colors/example-light.lua`:

```lua
---@type NeoDs.Theme
local theme = {
  name = "example-light",
  background = "light",

  primitives = {
    neutral = {
      ["0"] = "#ffffff",
      ["100"] = "#f0f0f0",
      ["600"] = "#68717a",
      ["1000"] = "#000000",
    },

    blue = {
      primary = "#0f68a0",
      selection = "#dcecff",
    },

    magenta = {
      primary = "#ad3da4",
    },

    red = {
      primary = "#d12f1b",
    },
  },

  palette = {
    background = {
      primary = "primitive.neutral.0",
      secondary = "primitive.neutral.100",
      selection = "primitive.blue.selection",
    },

    foreground = {
      primary = "primitive.neutral.1000",
      secondary = "primitive.neutral.600",
    },

    accent = {
      primary = "primitive.blue.primary",
      secondary = "primitive.magenta.primary",
    },

    feedback = {
      danger = "primitive.red.primary",
    },

    syntax = {
      keyword = {
        primary = "accent.secondary",
        secondary = "foreground.primary",
      },
    },
  },
}

require("neo-ds").load(require("neo-ds.theme").define(theme))
```

For larger themes, annotating subtrees can make the registry easier to use while editing:

```lua
---@type NeoDs.ThemePalette
local palette = {
  background = {
    primary = "primitive.neutral.0",
    secondary = "primitive.neutral.100",
    cursorline = "primitive.neutral.50",
  },
  syntax = {
    keyword = {
      primary = "accent.secondary",
      secondary = "foreground.secondary",
    },
    ["function"] = {
      _ = "accent.tertiary",
      definition = "syntax.function",
    },
  },
}
```

## Similar Projects

There are several good Neovim color tools in this space. They differ mostly in where they put the customization boundary.

| Project | What it optimizes for | Customization model | How `neo-ds` differs |
| --- | --- | --- | --- |
| `neo-ds` | A semantic mapping layer between theme palettes, user intent, and Neovim/plugin highlight groups. | Install a concrete theme, then override semantic palette values, roles, or final highlight mappings when needed. | Baseline for this comparison. It is deliberately a framework, not a theme gallery, generator, exporter, or picker. |
| [themer.lua](https://github.com/ThemerCorp/themer.lua) | A bundled theme system with supported plugin mappings, palette remaps, highlight remaps, live reload, picker, installer, and exports. | Choose a bundled theme, adjust styles, remap palette or highlights, enable plugin groups. | This is the closest conceptual neighbor. `neo-ds` is narrower: it does not try to be a theme gallery, installer, exporter, or picker. It focuses on a strict semantic role layer that separate theme packages can target. |
| [nvim-highlite](https://github.com/Iron-E/nvim-highlite) | A colorscheme generator with built-in schemes, custom schemes from a small set of colors, semantic-highlighting compatibility, plugin/syntax generation controls, highlight-group utilities, and exports. | Pick or generate a colorscheme, configure which highlight groups are generated, customize generated groups, and export themes to other formats. | This is the closest generator-side neighbor. `neo-ds` does not generate a full theme from a few colors or export themes; it provides a typed semantic contract between concrete themes, user overrides, and integrations. |
| [lush.nvim](https://github.com/rktjmp/lush.nvim) | Authoring colorschemes with live feedback, color manipulation, structure, and export options. | Write a theme through Lush's Lua DSL, often close to highlight-group definitions. | Lush is a theme creation aid. `neo-ds` is a runtime semantic mapping layer for themes and integrations. |
| [colorbuddy.nvim](https://github.com/tjdevries/colorbuddy.nvim) | Quick Lua-based colorscheme construction with named colors, groups, and color operations. | Define `Color` and `Group` values, including groups derived from other groups. | Colorbuddy makes highlight authoring nicer. `neo-ds` tries to avoid direct highlight authoring for normal customization by routing changes through roles. |
| [base16-nvim](https://github.com/RRethy/base16-nvim) | Building Neovim colorschemes from the Base16 palette convention, including LSP and Tree-sitter support. | Provide or select a 16-color Base16 palette. | Base16 is deliberately compact and portable. `neo-ds` uses a larger semantic vocabulary so plugin UI concepts can be tuned by meaning, not only by palette slot. |
| [mini.hues](https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-hues.md) | Generating configurable color schemes from background, foreground, hue count, saturation, and accent options. | Configure generator inputs and optional plugin integration. | `mini.hues` is a generator. `neo-ds` is a contract between concrete themes, user overrides, and highlight integrations. |

The tradeoff is intentional: `neo-ds` is less useful if you want a large catalog of ready-made themes or export targets. It is more useful if your problem is keeping editor, syntax, diagnostics, picker, explorer, completion, and plugin UI colors consistent through semantic decisions like `interaction.match`, `entity.directory`, `float.border`, or `diagnostic.error`.

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
    accent = {
      primary = "#0f62fe",
    },
  },
  roles = {
    ["entity.directory"] = { fg = "accent.primary", style = "bold" },
  },
  highlights = {
    MyHighlight = "interaction.match",
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
