;; extends

; Keep decorator names on @attribute while giving the marker its own role.
((decorator
  "@" @punctuation.special.annotation)
  (#set! priority 130))

; A language server may classify a decorated method definition as a property.
; Preserve function-definition styling on the declaration name while allowing
; property styling at reference sites.
((function_definition
  name: (identifier) @function)
  (#set! priority 130))

; Python builtin type names such as `set` and `type` are valid attribute
; names. When they appear as attributes, keep member/call styling instead of
; layering builtin type styling on top.
((attribute
  attribute: (identifier) @none)
  (#set! priority 101))

((call
  function: (attribute
    attribute: (identifier) @function.method.call))
  (#set! priority 102))
