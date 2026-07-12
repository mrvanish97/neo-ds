---@meta

---A color reference. Use a hex color, `NONE`, a primitive reference such as
---`primitive.blue.primary`, or another semantic token such as `accent.primary`.
---@alias NeoDs.ColorRef string

---Theme background mode passed through to `vim.o.background`.
---@alias NeoDs.Background "light"|"dark"

---Background colors for completion menus, popups, and popup scrollbars.
---@class (exact) NeoDs.BackgroundPopupPalette
---@field _? NeoDs.ColorRef Popup body background.
---@field selected? NeoDs.ColorRef Selected popup item background.
---@field scrollbar? NeoDs.ColorRef Popup scrollbar track background.
---@field thumb? NeoDs.ColorRef Popup scrollbar thumb background.

---Background colors for search matches.
---@class (exact) NeoDs.BackgroundSearchPalette
---@field _? NeoDs.ColorRef Ordinary search match background.
---@field active? NeoDs.ColorRef Active search match background.

---Background colors for LSP references and illuminated words.
---@class (exact) NeoDs.BackgroundReferencePalette
---@field _? NeoDs.ColorRef Standard reference highlight background.
---@field subtle? NeoDs.ColorRef Lower-emphasis reference highlight background.
---@field write? NeoDs.ColorRef Write-reference highlight background.

---Semantic status colors used for diagnostics, messages, VCS, and status UI.
---@class (exact) NeoDs.FeedbackPalette
---@field info? NeoDs.ColorRef Informational state color.
---@field hint? NeoDs.ColorRef Hint, suggestion, or low-severity state color.
---@field success? NeoDs.ColorRef Success, OK, addition, or positive state color.
---@field warning? NeoDs.ColorRef Warning, caution, or medium-severity state color.
---@field danger? NeoDs.ColorRef Error, deletion, destructive, or high-severity state color.

---Surface and state backgrounds.
---@class (exact) NeoDs.BackgroundPalette
---@field primary? NeoDs.ColorRef Base background tier; `background.editor` defaults to this.
---@field secondary? NeoDs.ColorRef Alternate surface tier for sidebars, floats, popups, and folds.
---@field tertiary? NeoDs.ColorRef Neutral surface tier used by non-text and scrollbar tracks.
---@field quaternary? NeoDs.ColorRef Strong neutral tier used by default borders and scrollbar thumbs.
---@field cursorline? NeoDs.ColorRef Cursor line and current-row background.
---@field selection? NeoDs.ColorRef Visual selection and selected item background.
---@field editor? NeoDs.ColorRef Main editable text area background.
---@field sidebar? NeoDs.ColorRef Sidebar and file tree background.
---@field float? NeoDs.ColorRef Floating window background.
---@field popup? NeoDs.BackgroundPopupPalette Popup-menu background tokens.
---@field search? NeoDs.BackgroundSearchPalette Search-match background tokens.
---@field reference? NeoDs.BackgroundReferencePalette Reference-highlight background tokens.
---@field feedback? NeoDs.FeedbackPalette Tinted feedback backgrounds, typically for diffs.

---Text and foreground colors.
---@class (exact) NeoDs.ForegroundPalette
---@field primary? NeoDs.ColorRef Default readable foreground.
---@field secondary? NeoDs.ColorRef Lower-emphasis readable foreground.
---@field muted? NeoDs.ColorRef Muted, dimmed, or inactive foreground.
---@field inverse? NeoDs.ColorRef Foreground used on accent or strong colored backgrounds.
---@field disabled? NeoDs.ColorRef Disabled foreground token; defaults to `foreground.muted`.
---@field deprecated? NeoDs.ColorRef Deprecated foreground, usually paired with strikethrough.
---@field link? NeoDs.ColorRef Link and URI foreground.

---Border and separator colors.
---@class (exact) NeoDs.BorderPalette
---@field primary? NeoDs.ColorRef Default border, separator, and guide color.
---@field secondary? NeoDs.ColorRef Lower-emphasis border or separator color.
---@field subtle? NeoDs.ColorRef Subtle border token; defaults to `border.secondary`.
---@field focus? NeoDs.ColorRef Focused border color for active inputs or panes.

---Accent colors used to distinguish syntax and interactive UI.
---@class (exact) NeoDs.AccentPalette
---@field primary? NeoDs.ColorRef Main accent color.
---@field secondary? NeoDs.ColorRef Secondary accent used by default keyword and insert-mode tokens.
---@field tertiary? NeoDs.ColorRef Tertiary accent used by default function-related tokens.
---@field quaternary? NeoDs.ColorRef Quaternary accent used by parameter, icon, and special-item mappings.
---@field literal? NeoDs.ColorRef Literal-value accent for constants and matches.
---@field note? NeoDs.ColorRef Note accent used by preprocessors and some annotation-like punctuation.

---Interactive state colors.
---@class (exact) NeoDs.InteractionPalette
---@field active? NeoDs.ColorRef Active control or currently actionable item color.
---@field focus? NeoDs.ColorRef Focused input or focused pane color.
---@field hover? NeoDs.ColorRef Interactive hover background token; defaults to `background.cursorline`.
---@field selected? NeoDs.ColorRef Selected item background.
---@field match? NeoDs.ColorRef Matched text color for search, completion, and pickers.

---Directory-specific entity colors.
---@class (exact) NeoDs.EntityDirectoryPalette
---@field _? NeoDs.ColorRef Directory name foreground.
---@field icon? NeoDs.ColorRef Directory icon foreground.

---Filesystem and navigable entity colors.
---@class (exact) NeoDs.EntityPalette
---@field file? NeoDs.ColorRef File name foreground.
---@field directory? NeoDs.EntityDirectoryPalette Directory foreground tokens.
---@field link? NeoDs.ColorRef Entity-level link token; defaults to `foreground.link`.

---Keyword-family syntax colors.
---@class (exact) NeoDs.SyntaxKeywordPalette
---@field _? NeoDs.ColorRef Default keyword color.
---@field primary? NeoDs.ColorRef Control-flow, declaration, and structural keyword color.
---@field secondary? NeoDs.ColorRef Modifier, import, operator-keyword, and qualifier color.
---@field directive? NeoDs.ColorRef Preprocessor or directive keyword color.

---Type-family syntax colors.
---@class (exact) NeoDs.SyntaxTypePalette
---@field _? NeoDs.ColorRef Type, class, interface, enum, and struct color.
---@field parameter? NeoDs.ColorRef Type parameter and generic parameter color.

---Function-family syntax colors.
---@class (exact) NeoDs.SyntaxFunctionPalette
---@field _? NeoDs.ColorRef Default function color.
---@field call? NeoDs.ColorRef Function or method call color.
---@field definition? NeoDs.ColorRef Function or method definition color.

---Markup syntax colors.
---@class (exact) NeoDs.SyntaxMarkupPalette
---@field heading? NeoDs.ColorRef Markdown or markup heading color.
---@field raw? NeoDs.ColorRef Raw text, code span, and code block color.

---Code and markup syntax colors.
---@class (exact) NeoDs.SyntaxPalette
---@field comment? NeoDs.ColorRef Comment and documentation comment color.
---@field keyword? NeoDs.SyntaxKeywordPalette Keyword-family syntax tokens.
---@field annotation? NeoDs.ColorRef Annotation, attribute, or decorator color.
---@field variable? NeoDs.ColorRef Variable, parameter, namespace, and module color.
---@field property? NeoDs.ColorRef Object property, member, and field color.
---@field constant? NeoDs.ColorRef Constant and enum member color.
---@field string? NeoDs.ColorRef String and character literal color.
---@field number? NeoDs.ColorRef Number and floating-point literal color.
---@field boolean? NeoDs.ColorRef Boolean literal color.
---@field operator? NeoDs.ColorRef Operator color.
---@field punctuation? NeoDs.ColorRef Delimiter and punctuation color.
---@field bracket? NeoDs.ColorRef Bracket, brace, and parenthesis color.
---@field preprocessor? NeoDs.ColorRef Preprocessor, macro, and directive color.
---@field builtin? NeoDs.ColorRef Builtin variable, type, function, or module color.
---@field tag? NeoDs.ColorRef Markup, HTML, XML, and JSX tag color.
---@field type? NeoDs.SyntaxTypePalette Type-family syntax tokens.
---@field ["function"]? NeoDs.SyntaxFunctionPalette Function-family syntax tokens.
---@field markup? NeoDs.SyntaxMarkupPalette Markup syntax tokens.

---Version-control status colors.
---@class (exact) NeoDs.VcsPalette
---@field added? NeoDs.ColorRef Added file, line, or hunk color.
---@field changed? NeoDs.ColorRef Modified file, line, or hunk color.
---@field deleted? NeoDs.ColorRef Deleted file, line, or hunk color.
---@field untracked? NeoDs.ColorRef Untracked file color.

---Mode indicator colors.
---@class (exact) NeoDs.ChromeModePalette
---@field normal? NeoDs.ColorRef Normal-mode indicator background.
---@field insert? NeoDs.ColorRef Insert-mode indicator background.
---@field visual? NeoDs.ColorRef Visual-mode indicator background.
---@field replace? NeoDs.ColorRef Replace-mode indicator background.
---@field command? NeoDs.ColorRef Command-mode indicator background.

---Editor chrome colors such as statuslines, tablines, winbars, and mode UI.
---@class (exact) NeoDs.ChromePalette
---@field base? NeoDs.ColorRef Active chrome background.
---@field inactive? NeoDs.ColorRef Inactive chrome background.
---@field mode? NeoDs.ChromeModePalette Mode indicator background tokens.

---Semantic palette contract for concrete themes.
---@class (exact) NeoDs.ThemePalette
---@field background? NeoDs.BackgroundPalette Surface and state backgrounds.
---@field foreground? NeoDs.ForegroundPalette Text and foreground colors.
---@field border? NeoDs.BorderPalette Borders, separators, and guides.
---@field accent? NeoDs.AccentPalette Accent colors for syntax and UI.
---@field interaction? NeoDs.InteractionPalette Active, focused, selected, and matched states.
---@field feedback? NeoDs.FeedbackPalette Diagnostics, messages, and semantic status colors.
---@field entity? NeoDs.EntityPalette Files, directories, links, and related entities.
---@field syntax? NeoDs.SyntaxPalette Code and markup syntax colors.
---@field vcs? NeoDs.VcsPalette Version-control status colors.
---@field chrome? NeoDs.ChromePalette Statusline, winbar, tabline, and mode colors.

---Primitive color tree for raw theme colors. Concrete themes may choose any
---primitive names and nesting shape.
---@alias NeoDs.PrimitiveTree table<string, NeoDs.ColorRef|NeoDs.PrimitiveTree>

---Concrete theme definition. Concrete themes are palette-only data and should be
---created through `require("neo-ds.theme").define()`.
---@class (exact) NeoDs.Theme
---@field name string Human-readable and colorscheme-facing theme name.
---@field background NeoDs.Background Light or dark background mode.
---@field primitives NeoDs.PrimitiveTree Raw reusable color values.
---@field palette NeoDs.ThemePalette Semantic palette overrides.

return {}
