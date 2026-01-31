shader_type canvas_item;

uniform float radius : hint_range(0.0, 1.0) = 0.0;

void fragment() {
	vec2 centered_uv = (UV * 2.0) - 1.0;
	float dist = length(centered_uv);

	if (dist <= radius)
		COLOR = vec4(0.0);
}
