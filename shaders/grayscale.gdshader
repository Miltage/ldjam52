shader_type canvas_item;
render_mode unshaded;

void fragment() {
	COLOR = texture(TEXTURE, UV);
    float lum = (COLOR.r+COLOR.g+COLOR.b)/3.0;
    COLOR.xyz = vec3(lum);
}
