shader_type canvas_item;

uniform vec3 start_color : source_color;
uniform vec3 end_color : source_color;

void fragment() {
	// Called for every pixel the material is visible on.
	float value = abs(sin(UV.x * 50.0 + sin(UV.y * 20.0) + TIME) + sin(UV.y * TIME * .05 + UV.x * 80.0));
	vec3 final_color = mix(start_color, end_color, value);
	COLOR = vec4(final_color, 1);
}
