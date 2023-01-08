shader_type spatial;
render_mode blend_mix,depth_draw_opaque,unshaded,cull_disabled;
uniform vec4 albedo : source_color = vec4(1.0);
uniform sampler2D texture_albedo : source_color,filter_linear_mipmap,repeat_enable;
uniform float point_size : hint_range(0,128) = 1;
uniform float roughness : hint_range(0,1) = 1;
uniform sampler2D texture_metallic : hint_default_white,filter_linear_mipmap,repeat_enable;
uniform vec4 metallic_texture_channel;
uniform sampler2D texture_roughness : hint_roughness_r,filter_linear_mipmap,repeat_enable;
uniform float specular = 0.5;
uniform float metallic;
uniform vec3 uv1_scale = vec3(1.0);
uniform vec3 uv1_offset;
uniform vec3 uv2_scale = vec3(1.0);
uniform vec3 uv2_offset;

const bool enabled = true;

void vertex() {
	vec4 world_vertex = MODEL_MATRIX * vec4(VERTEX, 1.0);
	vec3 temp = INV_VIEW_MATRIX[3].xyz - world_vertex.xyz;
	float dist = length(temp);
	if (enabled) world_vertex.y -= pow(dist * 0.1, 2.2);
	vec4 local_vertex = inverse(MODEL_MATRIX) * world_vertex;
	VERTEX = local_vertex.xyz;
}

void fragment() {
	vec2 base_uv = UV;
	vec4 albedo_tex = texture(texture_albedo,base_uv);
	ALBEDO = albedo.rgb * albedo_tex.rgb;
	float metallic_tex = dot(texture(texture_metallic,base_uv),metallic_texture_channel);
	METALLIC = metallic_tex * metallic;
	vec4 roughness_texture_channel = vec4(1.0,0.0,0.0,0.0);
	float roughness_tex = dot(texture(texture_roughness,base_uv),roughness_texture_channel);
	ROUGHNESS = roughness_tex * roughness;
	SPECULAR = specular;
}