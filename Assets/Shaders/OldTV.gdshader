shader_type canvas_item;

uniform vec2 curvature;
uniform vec2 screenResolution;
uniform vec2 screenOpacity;

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
	
	COLOR *= scanLineIntensity(uv.x, screenResolution.x, screenOpacity.x, -0.30);
	COLOR *= scanLineIntensity(uv.y, screenResolution.y, screenOpacity.y, -0.25);
	
	float xVignette = clamp(pow(uv.x * (1.0-uv.x) * screenResolution.x / 30.0, 0.8), 0.0, 1.0);
	float yVignette = clamp(pow(uv.y * (1.0-uv.y) * screenResolution.y / 30.0, 0.8), 0.0, 1.0);
	
	COLOR = COLOR * vec4(vec3(xVignette * yVignette), 1.0);
	
	if(uv.x < 0.001 || uv.y < 0.001 || uv.x > 0.999 || uv.y > 0.999) {
		COLOR = vec4(0.5 * COLOR.rgb, 1.0);
	}
	
	if(uv.x < 0.0005 || uv.y < 0.0005 || uv.x > 0.9995 || uv.y > 0.9995) {
		COLOR = vec4(0.5 * COLOR.rgb, 1.0);
	}
	
	if(uv.x < 0.0 || uv.y < 0.0 || uv.x > 1.0 || uv.y > 1.0) {
		COLOR = vec4(0.0, 0.0, 0.0, 1.0);
	}
}