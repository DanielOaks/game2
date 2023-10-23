shader_type canvas_item;

uniform vec3 start_color : source_color;
uniform vec3 end_color : source_color;

void fragment() {
	// Called for every pixel the material is visible on.
	float value = abs(sin(UV.x * 3.0 + TIME * 2.0) + cos(UV.y * 3.0 + TIME) + sin(UV.x * 3.0 * UV.y + TIME * 3.0));
	vec3 final_color = mix(start_color, end_color, value);
	COLOR = vec4(final_color, 1);
}
