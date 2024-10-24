vec4 position(mat4 transform_projection, vec4 vertex_position)
{
    return transform_projection * vertex_position;
}

extern float red;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
{
    vec4 pixel = Texel(texture, texture_coords);
    if (pixel.a != 0.0)
    {
        pixel = (1 - red) * pixel + red * vec4(1.0, 0.0, 0.0, 1.0);
    }
    return pixel;
}