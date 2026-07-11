;; extends

; Keep annotation names on @attribute while giving the marker its own role.
((annotation
  "@" @punctuation.special.annotation)
  (#set! priority 110))

((marker_annotation
  "@" @punctuation.special.annotation)
  (#set! priority 110))
