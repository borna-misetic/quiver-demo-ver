shader_type canvas_item;

uniform bool whiten = false;

void fragment(){
	vec4 textureColor = texture(TEXTURE, UV);
	if(whiten){
		vec3 white = vec3(1,1,1);
		vec3 whiteTexture = mix(textureColor.rgb, white, 1);
		COLOR = vec4(whiteTexture, textureColor.a);
	}
	else{
		COLOR = textureColor;
	}
}