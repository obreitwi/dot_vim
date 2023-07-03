;; extends

; embed sql in literals
(
 (comment) @_tag (#eq? @_tag "/* sql */")
 (raw_string_literal) @sql (#offset! @sql 0 1 0 -1)
)

(
 (comment) @_tag (#eq? @_tag "/* sql */")
 (expression_list (raw_string_literal) @sql (#offset! @sql 0 1 0 -1))
)

; TODO: This also matches go literals in the middle but there is no way to
; specifically match all "raw_string_literals" within a possibly complex
; binary_expression tree yet
(
    (comment) @_tag (#eq? @_tag "/* sql */")
    (expression_list) @sql (#offset! @sql 0 1 0 -1)
)
