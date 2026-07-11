---@meta

---@alias NeoDs.ColorRef string
---@alias NeoDs.Background "light"|"dark"

---@class (exact) NeoDs.BackgroundPopupPalette
---@field _? NeoDs.ColorRef
---@field selected? NeoDs.ColorRef
---@field scrollbar? NeoDs.ColorRef
---@field thumb? NeoDs.ColorRef

---@class (exact) NeoDs.BackgroundSearchPalette
---@field _? NeoDs.ColorRef
---@field active? NeoDs.ColorRef

---@class (exact) NeoDs.BackgroundReferencePalette
---@field _? NeoDs.ColorRef
---@field subtle? NeoDs.ColorRef
---@field write? NeoDs.ColorRef

---@class (exact) NeoDs.FeedbackPalette
---@field info? NeoDs.ColorRef
---@field hint? NeoDs.ColorRef
---@field success? NeoDs.ColorRef
---@field warning? NeoDs.ColorRef
---@field danger? NeoDs.ColorRef

---@class (exact) NeoDs.BackgroundPalette
---@field primary? NeoDs.ColorRef
---@field secondary? NeoDs.ColorRef
---@field tertiary? NeoDs.ColorRef
---@field quaternary? NeoDs.ColorRef
---@field cursorline? NeoDs.ColorRef
---@field selection? NeoDs.ColorRef
---@field editor? NeoDs.ColorRef
---@field sidebar? NeoDs.ColorRef
---@field float? NeoDs.ColorRef
---@field popup? NeoDs.BackgroundPopupPalette
---@field search? NeoDs.BackgroundSearchPalette
---@field reference? NeoDs.BackgroundReferencePalette
---@field feedback? NeoDs.FeedbackPalette

---@class (exact) NeoDs.ForegroundPalette
---@field primary? NeoDs.ColorRef
---@field secondary? NeoDs.ColorRef
---@field muted? NeoDs.ColorRef
---@field inverse? NeoDs.ColorRef
---@field disabled? NeoDs.ColorRef
---@field deprecated? NeoDs.ColorRef
---@field link? NeoDs.ColorRef

---@class (exact) NeoDs.BorderPalette
---@field primary? NeoDs.ColorRef
---@field secondary? NeoDs.ColorRef
---@field subtle? NeoDs.ColorRef
---@field focus? NeoDs.ColorRef

---@class (exact) NeoDs.AccentPalette
---@field primary? NeoDs.ColorRef
---@field secondary? NeoDs.ColorRef
---@field tertiary? NeoDs.ColorRef
---@field quaternary? NeoDs.ColorRef
---@field literal? NeoDs.ColorRef
---@field note? NeoDs.ColorRef

---@class (exact) NeoDs.InteractionPalette
---@field active? NeoDs.ColorRef
---@field focus? NeoDs.ColorRef
---@field hover? NeoDs.ColorRef
---@field selected? NeoDs.ColorRef
---@field match? NeoDs.ColorRef

---@class (exact) NeoDs.EntityDirectoryPalette
---@field _? NeoDs.ColorRef
---@field icon? NeoDs.ColorRef

---@class (exact) NeoDs.EntityPalette
---@field file? NeoDs.ColorRef
---@field directory? NeoDs.EntityDirectoryPalette
---@field link? NeoDs.ColorRef

---@class (exact) NeoDs.SyntaxKeywordPalette
---@field _? NeoDs.ColorRef
---@field primary? NeoDs.ColorRef
---@field secondary? NeoDs.ColorRef
---@field directive? NeoDs.ColorRef

---@class (exact) NeoDs.SyntaxTypePalette
---@field _? NeoDs.ColorRef
---@field parameter? NeoDs.ColorRef

---@class (exact) NeoDs.SyntaxFunctionPalette
---@field _? NeoDs.ColorRef
---@field call? NeoDs.ColorRef
---@field definition? NeoDs.ColorRef

---@class (exact) NeoDs.SyntaxMarkupPalette
---@field heading? NeoDs.ColorRef
---@field raw? NeoDs.ColorRef

---@class (exact) NeoDs.SyntaxPalette
---@field comment? NeoDs.ColorRef
---@field keyword? NeoDs.SyntaxKeywordPalette
---@field annotation? NeoDs.ColorRef
---@field variable? NeoDs.ColorRef
---@field property? NeoDs.ColorRef
---@field constant? NeoDs.ColorRef
---@field string? NeoDs.ColorRef
---@field number? NeoDs.ColorRef
---@field boolean? NeoDs.ColorRef
---@field operator? NeoDs.ColorRef
---@field punctuation? NeoDs.ColorRef
---@field bracket? NeoDs.ColorRef
---@field preprocessor? NeoDs.ColorRef
---@field builtin? NeoDs.ColorRef
---@field tag? NeoDs.ColorRef
---@field type? NeoDs.SyntaxTypePalette
---@field ["function"]? NeoDs.SyntaxFunctionPalette
---@field markup? NeoDs.SyntaxMarkupPalette

---@class (exact) NeoDs.VcsPalette
---@field added? NeoDs.ColorRef
---@field changed? NeoDs.ColorRef
---@field deleted? NeoDs.ColorRef
---@field untracked? NeoDs.ColorRef

---@class (exact) NeoDs.ChromeModePalette
---@field normal? NeoDs.ColorRef
---@field insert? NeoDs.ColorRef
---@field visual? NeoDs.ColorRef
---@field replace? NeoDs.ColorRef
---@field command? NeoDs.ColorRef

---@class (exact) NeoDs.ChromePalette
---@field base? NeoDs.ColorRef
---@field inactive? NeoDs.ColorRef
---@field mode? NeoDs.ChromeModePalette

---@class (exact) NeoDs.ThemePalette
---@field background? NeoDs.BackgroundPalette
---@field foreground? NeoDs.ForegroundPalette
---@field border? NeoDs.BorderPalette
---@field accent? NeoDs.AccentPalette
---@field interaction? NeoDs.InteractionPalette
---@field feedback? NeoDs.FeedbackPalette
---@field entity? NeoDs.EntityPalette
---@field syntax? NeoDs.SyntaxPalette
---@field vcs? NeoDs.VcsPalette
---@field chrome? NeoDs.ChromePalette

---@alias NeoDs.PrimitiveTree table<string, NeoDs.ColorRef|NeoDs.PrimitiveTree>

---@class (exact) NeoDs.Theme
---@field name string
---@field background NeoDs.Background
---@field primitives NeoDs.PrimitiveTree
---@field palette NeoDs.ThemePalette

return {}
