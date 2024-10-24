function scale_vector(vec, scalar)
    local v = create_vector()
    v.x = vec.x * scalar
    v.y = vec.y * scalar
    return v
end

function add_vectors(vec1, vec2)
    local v = create_vector()
    v.x = vec1.x + vec2.x
    v.y = vec1.y + vec2.y
    return v
end

function sub_vectors(vec1, vec2)
    local v = create_vector()
    v.x = vec1.x - vec2.x
    v.y = vec1.y - vec2.y
    return v
end

vector_meta = {
    __mul = function(var1, var2)
        if type(var1) == "table" and type(var2) == "number" then
            return scale_vector(var1, var2)
        elseif type(var1) == "number" and type(var2) == "table" then
            return scale_vector(var2, var1)
        else
            error("Invalid multiplication")
        end
    end,
    __add = function(var1, var2)
        if type(var1) == "table" and type(var2) == "table" then
            return add_vectors(var1, var2)
        else
            error("Invalid addition")
        end
    end,
    __sub = function(var1, var2)
        if type(var1) == "table" and type(var2) == "table" then
            return sub_vectors(var1, var2)
        else
            error("Invalid addition")
        end
    end
}

vector = {
    x = 0.0,
    y = 0.0,
    is_vector = true
}

function vector:is_zero_vec()
    return self.x == 0.0 and self.y == 0.0
end

function normalize_vector(vec)
    local vecLenth = math.sqrt(vec.x ^ 2 + vec.y ^ 2)
    vec.x = vec.x / vecLenth
    vec.y = vec.y / vecLenth
end

function rotate_vector(vec, degrees)
    local radians = math.rad(degrees)
    local vec2 = create_vector()
    vec2.x = vec.x * math.cos(radians) - vec.y * math.sin(radians)
    vec2.y = vec.y * math.cos(radians) + vec.x * math.sin(radians)
    return vec2
end

function create_vector()
    return setmetatable(copy_table(vector, vector.is_vector), vector_meta)
end

function calculate_distance(vec1, vec2)
    return math.sqrt((vec1.x - vec2.x) ^ 2 + (vec1.y - vec2.y) ^ 2)
end
