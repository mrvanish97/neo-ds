# Backlog

## Unused symbols and imports highlighting

Investigate whether `neo-ds` should give unused imports, unused local symbols, and other dead-code hints a distinct semantic treatment.

Current state:

- `neo-ds` already maps Neovim diagnostics to `diagnostic.error`, `diagnostic.warn`, `diagnostic.info`, `diagnostic.hint`, and `diagnostic.ok`.
- There is no dedicated `unused` token in the current semantic palette or role contract.
- Unused imports/symbols will only be highlighted if the language server or diagnostic source reports them through one of the existing diagnostic groups.

Possible directions:

1. Keep the current model and document that unused items inherit diagnostic styling.
2. Add a dedicated semantic role or diagnostic mapping for `unused` if a supported server exposes a stable group for it.
3. Add a minimal integration-specific override for common servers if the signal is useful and stable enough.

The default bias should be to avoid adding a new token unless there is a clear cross-language mapping that stays stable across supported tools.
