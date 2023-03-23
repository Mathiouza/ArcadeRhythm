shader_type canvas_item;

uniform vec2 curvature;
uniform vec2 screenResolution;
uniform vec2 screenOpacity;
uniform float time;
uniform float brillance;
uniform float red;
uniform bool isWhiteShiny;

const float PI = 3.141592;

vec4 scanLineIntensity(float uv, float resolution, float opacity, float offset)
{
	float intensity = sin((uv * resolution + offset) * PI * 2.0);
	intensity = ((0.5 * intensity) + 0.5) + 0.5;
	return vec4(vec3(pow(intensity, opacity)), 1.0);
}

void fragment() {
	
	vec2 uv = vec2(UV.x, UV.y);
	uv = uv * 2.0-1.0;
	
	vec2 offset = abs(uv.yx) / vec2(curvature.x, curvature.y);
	uv = uv + uv * offset * offset;
	uv = uv * 0.5 + 0.5;
	
	COLOR = vec4(0);
	
	for(float x = -0.3 ; x <= 0.3 ; x += 0.1) {
		for(float y = -0.3 ; y <= 0.3 ; y += 0.1) {
			COLOR += texture(TEXTURE, uv + vec2(x * 1.0 / screenResolution.x , y * 1.0 / screenResolution.y)) / 49.0;
		}
	}
	
	COLOR += brillance;
	
	COLOR += (0.5 - distance(vec2(0.5, 0.5), uv)) * (vec4(2.0, 0.7, 0.7, 0.0) * red);
	
	COLOR *= scanLineIntensity(uv.x, screenResolution.x, screenOpacity.x, -0.30);
	COLOR *= scanLineIntensity(uv.y, screenResolution.y, screenOpacity.y, -0.25);
	
	float xVignette = clamp(pow(uv.x * (1.0-uv.x) * screenResolution.x / 30.0, 0.8), 0.0, 1.0);
	float yVignette = clamp(pow(uv.y * (1.0-uv.y) * screenResolution.y / 30.0, 0.8), 0.0, 1.0);
	
	COLOR *= vec4(vec3(xVignette * yVignette), 1.0);
	
	vec2 pixelWidthInUvWorld = 1.0 / screenResolution;
	bool finish = false;
	for(int i = 1 ; i < 10 ; i++) {
		for(int j = 0 ; j < 16 ; j++) {
			vec2 new_uv = uv + vec2(cos(float(j) * PI / 8.0), -sin(float(j) * PI / 8.0)) * float(i) * pixelWidthInUvWorld;
			vec4 new_color = texture(TEXTURE, new_uv);
			
			float luminance = new_color.r * 0.2126 + new_color.g * 0.7152 + new_color.b * 0.0722;
			
			if(luminance > 0.4 && luminance < 0.5 || isWhiteShiny && luminance > 0.9 ||
				new_color.r > 0.944 && new_color.r < 0.946 && new_color.g > 0.191 && new_color.g < 0.193 && new_color.b > 0.070 && new_color.b < 0.073 || 
				new_color.r > 0.159 && new_color.r < 0.161 && new_color.g > 0.657 && new_color.g < 0.659 && new_color.b > 0.321 && new_color.b < 0.323) {
				COLOR += vec4(new_color.rgb * vec3(float(10-i)), 0.0) * 0.05;
				finish = true;
				break;
			}
		}
		
		if(finish) {
			break;
		}
	}
	
	/* 204 115 29 0.8 0.45 0.101
	241 49 18   0.945 0.192 0.071
	41 268 82 0.16 0.658 0.322
	float bornedTime = time;
	while(bornedTime >= 10.0) bornedTime -= 10.0;
	
	COLOR *= vec4(vec3(clamp(-5000.0*pow((1.0-uv.y) - bornedTime / 10.0, 2.0) + 1.0, 0.0, 1.0) + 1.0), 1.0);
	*/
}