function copy_table(t, is_vector)
    local t2 = {}
    if is_vector then
        setmetatable(t2, vector_meta)
    end
    for k, v in pairs(t) do
        t2[k] = type(v) == "table" and copy_table(v, is_vector) or v
    end
    return t2
end
