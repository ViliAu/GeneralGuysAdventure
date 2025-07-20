shader_type canvas_item;

uniform vec3 color: source_color = vec3(1.0, 1.0, 1.0);
uniform float tint_intensity: hint_range(0.0, 1.0) = 0.5;

void fragment() {
	vec4 input_color = texture(TEXTURE, UV);
	COLOR.rgb = mix(input_color.rgb * (1.0 - tint_intensity), color * tint_intensity, tint_intensity);
}
