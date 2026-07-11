;; extends

; Lua tables capture their braces as both @constructor and
; @punctuation.bracket. Prefer punctuation styling for the delimiters only.
(["{" "}"] @punctuation.bracket
  (#set! priority 110))
