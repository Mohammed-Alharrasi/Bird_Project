shader_type canvas_item;

uniform vec4 color : source_color = vec4(0.305, 0.298, 0.341,1);

void fragment() {
	COLOR = vec4(color.rgb, 1);
}
