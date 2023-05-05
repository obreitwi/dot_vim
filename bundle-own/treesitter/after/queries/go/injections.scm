;; extends

; embed sql in literals
(
 (comment) @_tag (#eq? @_tag "/* sql */")
 (expression_list (raw_string_literal) @sql)
)
