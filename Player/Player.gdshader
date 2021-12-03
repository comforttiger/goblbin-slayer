shader_type canvas_item;

uniform bool dash = false;
uniform bool white = false;

void fragment() {
	vec4 previousColor = texture(TEXTURE, UV);
	vec4 dashColor = vec4(previousColor.r + 1.0,previousColor.g,previousColor.b + 0.5,previousColor.a);
	vec4 whiteColor = vec4(previousColor.r + 0.5, previousColor.g - 0.5, previousColor.b - 0.5, previousColor.a);
	vec4 newColor = previousColor;
	if (dash == true) {
		newColor = dashColor;
	}
	if (white == true) {
		newColor = whiteColor
	}
	COLOR = newColor;
}