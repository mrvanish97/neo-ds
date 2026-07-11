# AGENTS.md

## Project intent

`neo-ds` stands for Neovim Design System. It is a semantic colorscheme framework for Neovim. Preserve the data flow:

```text
primitives -> semantic palette -> roles -> highlight integrations
```

## Architecture rules

- Concrete themes must be palette-only data created with `require("neo-ds.theme").define()`.
- Concrete themes must not contain role or highlight overrides.
- Add reusable visual concepts to the semantic palette and roles before mapping them to highlight groups.
- Integrations must consume semantic tokens or roles, never concrete primitive colors.
- Do not implement another palette or alias resolver. Reuse `neo-ds.compiler` through the public API where possible.
- Keep third-party plugin integrations isolated under `lua/neo-ds/integrations/`.
- Keep the framework usable when an integrated third-party plugin is absent.

## Style

- Use two-space indentation for Lua.
- Keep modules declarative and side-effect-free unless the Neovim API requires otherwise.
- Prefer precise, path-aware validation errors.
- Use LuaLS annotations for public contracts and APIs.

## Verification

Run these checks after changes:

```sh
nvim --headless -u NONE -l scripts/neo-ds-smoke.lua
nvim --headless -u NONE -l scripts/neo-ds-highlight-report.lua
```

Also run `git diff --check` before committing.
