shader_type canvas_item;

//uniform vec4 old_color:source_color;

group_uniforms		palette;
uniform sampler2D	paletteTexture: filter_nearest;
uniform float		paletteNumber: hint_range(0, 100, 1);

const float precision = 0.02;

vec4 get_replacement(vec4 color)
{
	// centre of the palette's pixel in y
	ivec2 paletteSize = textureSize(paletteTexture, 0);
	float selectedPaletteY = paletteNumber / float(paletteSize.y) + (1.0 / float(paletteSize.y)) * 0.5;
	float xMod = 1.0 / float(paletteSize.x);
	float currentX = xMod * .5;

	for (int i = 0; i < paletteSize.x; i += 1) {
		if (distance(color, texture(paletteTexture, vec2(currentX, 0.0))) <= precision) {
			return texture(paletteTexture, vec2(currentX, selectedPaletteY));
		}
		currentX += xMod;
	}

	return color;
}

void fragment()
{
	vec4 texture_color = texture(TEXTURE, UV);

	if (paletteNumber < 1.0) {
		/*COLOR = texture_color;
		COLOR.b -= texture_color.b;
		COLOR.g -= texture_color.g;*/
		COLOR = get_replacement(texture_color);
	} else {
		COLOR = get_replacement(texture_color);
	}
}
