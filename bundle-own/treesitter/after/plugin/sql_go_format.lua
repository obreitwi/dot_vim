-- local embedded_sql_queries = { 
    -- vim.treesitter.query.parse(
        -- "go",
        -- [[
            -- (
                -- (comment) @_tag (#eq? @_tag "/* sql */")
                -- (expression_list (raw_string_literal) @sql (#offset! @sql 0 1 0 -1))
            -- ),
        -- ]]
    -- ),
    -- vim.treesitter.query.parse(
        -- "go",
        -- [[
            -- (
                -- (comment) @_tag (#eq? @_tag "/* sql */")
                -- (expression_list) @sql (#offset! @sql 0 1 0 -1)
            -- )
        -- ]]
    -- ),
-- }
local embedded_sql = vim.treesitter.query.parse(
    "go",
    [[(
        (comment) @_tag (#eq? @_tag "/* sql */")
        (expression_list (raw_string_literal) @sql (#offset! @sql 0 1 0 -1))
    )]]
)

local tempfile = "/tmp/nvim_sql_formatting.sql"

local get_root = function(bufnr)
    local parser = vim.treesitter.get_parser(bufnr, "go", {})
    local tree = parser:parse()[1]
    return tree:root()
end

local handle_io = function(_, data)
    if data then
        for _, line in ipairs(data) do
            vim.notify(line, vim.log.levels.TRACE)
        end
    end
end

local format_sql = function(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()

    if vim.bo[bufnr].filetype ~= "go" then
        vim.notify("can only be called in go files")
        return
    end

    local root = get_root(bufnr)

    local changes = {}
    for id, node in embedded_sql:iter_captures(root, bufnr, 0, -1) do
        -- {start_row, start_col, end_row, end_col } = node:range()
        local range = { node:range() }
        -- local indentation = string.rep(" ", start_col)
        local name = embedded_sql.captures[id]

        if name == "sql" then
            local start_row = range[1] + 1

            local lines = vim.split(vim.treesitter.get_node_text(node, bufnr), "\n")
            table.remove(lines)
            table.remove(lines, 1)

            -- for i, l in ipairs(lines) do
                -- lines[i] = l:match'^%s*(.*%S)' or ''
            -- end

            -- nightly
            -- vim.fn.writefile(lines, tempfile, "D")
            vim.fn.writefile(lines, tempfile)

            vim.fn.jobstart({"sqlfluff", "format", "--dialect", "postgres", tempfile},
                {
                stdout_buffered = true,
                on_stdout = handle_io,
                on_stderr = handle_io,
            })

            local formatted = vim.fn.readfile(tempfile)
            if formatted[#formatted] == "" then
                table.remove(formatted)
            end

            -- for i, f in ipairs(formatted) do
                -- formatted[i] = indentation..f
            -- end

            table.insert(changes, 1, {
                start = start_row,
                final = range[3],
                formatted = formatted,
            })
        end
    end

    for _, change in ipairs(changes) do
        vim.api.nvim_buf_set_lines(bufnr, change.start, change.final, true, change.formatted)
    end
end

vim.api.nvim_create_user_command("SqlFormat", function()
    format_sql()
end, {})
