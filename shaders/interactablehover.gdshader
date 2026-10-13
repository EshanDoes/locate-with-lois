shader_type canvas_item;

uniform float size : hint_range(1.0, 100.0) = 8.0;
uniform vec4 color1 : source_color = vec4(0.7, 0.7, 0.7, 1.0); 
uniform vec4 color2 : source_color = vec4(0.4, 0.4, 0.4, 1.0);
uniform vec2 scrollSpeed = vec2(5, 5);

void fragment() {
	vec4 pixelColor = texture(TEXTURE, UV);
	if(pixelColor == vec4(1, 1, 1, 1)){
		vec2 pos = floor(FRAGCOORD.xy / size + scrollSpeed * TIME);
		float pattern_mask = mod(pos.x + mod(pos.y, 2.0), 2.0);
		COLOR = mix(color1, color2, pattern_mask);
	} else{
		COLOR = pixelColor;
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
