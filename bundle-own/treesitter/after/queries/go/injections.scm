;; extends

; embed sql in literals
(
 (comment) @_tag (#eq? @_tag "/* sql */")
 (expression_list (raw_string_literal) @sql (#offset! @sql 0 1 0 -1))
)
