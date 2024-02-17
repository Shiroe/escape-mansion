shader_type canvas_item;

uniform float light_position_x : hint_range(-4096, 4096) = 0.0;
uniform float light_position_y : hint_range(-4096, 4096) = 0.0;
uniform float light_radius : hint_range(0.0, 4096.0) = 128.0;

void vertex() {
    // Transform the vertex position as needed
    vec4 vertex_transformed = MODEL_MATRIX * vec4(VERTEX, 1.0, 0.0);
    VERTEX = vertex_transformed.xy;

    // Perform any other vertex transformations as needed
}
  
void fragment() {
    // Calculate the distance from the light source to the current pixel
    float distance_to_light = distance(FRAGCOORD.ab, vec2(light_position_x, light_position_y));

    // Calculate the alpha (transparency) based on the distance
    float alpha = smoothstep(light_radius, light_radius + 10.0, distance_to_light);

    // Set the final color with adjusted alpha
    COLOR = vec4(1.0, 1.0, 1.0, alpha);
}


//shader_type canvas_item;
//
//uniform vec2 light_position; // Position of the light source
//uniform float light_radius; // Distance at which the sprite is fully revealed
//
//void fragment() {
    //// Calculate the distance from the light source to the current fragment
    //float distance_to_light = distance(light_position, UV);
//
    //// Calculate the alpha (transparency) based on the distance
    ////float alpha = smoothstep(distance_to_light, 0.0, light_radius);
	//float alpha = clamp(light_radius, 0.0, 1.0);
//
    //// Sample the sprite's texture
    //vec4 sprite_color = texture(TEXTURE, UV);
//
    //// Set the final color with the sprite's color and the adjusted alpha
    //COLOR = vec4(sprite_color.rgb, sprite_color.a * alpha);
//}