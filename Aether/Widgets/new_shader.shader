shader_type spatial;

uniform vec3 box_size;

void vertex() {
	
	vec3 n = NORMAL;
	//n = vec3(0, 1, 0);
	mat3 space_transf = mat3(
		n.yzx, 
		n.zxy, 
		n.xyz
	);


	//space_transf = transpose(space_transf);
	vec3 vertex_to_01 = VERTEX * 0.5 + 0.5;
	
	//UV2 = ((VERTEX * uv_size * box_size)).xy;
	UV2 = (space_transf*(vertex_to_01 * box_size)).xy * 2.;
	UV2 = ((vertex_to_01 * box_size)*space_transf).xy * 2.;
}

uniform sampler2D base_color;

void fragment() {
	ALBEDO = vec3(UV2.xy, 0);
	ALBEDO = texture(base_color, UV2).xyz;
	// ALBEDO = vec3(UV2, 0);
}
