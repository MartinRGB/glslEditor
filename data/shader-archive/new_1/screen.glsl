// Author:
// Title:

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;
uniform sampler2D u_tex0;
uniform sampler2D u_tex16;
uniform sampler2D u_tex17;
uniform sampler2D u_tex18;
uniform sampler2D u_tex19;
uniform sampler2D u_tex20;
uniform vec2 u_tex0Resolution;
uniform float u_slot1;
uniform float u_slot2;
//Shader Toy Basic Uniform
#define iTime u_time
#define iResolution u_resolution
#define iMouse u_mouse
#define mTex u_tex16

vec3 brightnessContrast(vec3 value, float brightness, float contrast)
{
    return (value - 0.5) * contrast + 0.5 + brightness;
}

vec3 czm_saturation(vec3 rgb, float adjustment)
{
    const vec3 W = vec3(0.2125, 0.7154, 0.0721);
    vec3 intensity = vec3(dot(rgb, W));
    return mix(intensity, rgb, adjustment);
}

float circle(in vec2 _st, in float _radius,in vec2 _pos,in float blur){
    vec2 dist = vec2(_st.x,_st.y/108.*234.)-vec2(_pos.x,_pos.y /108.*234.);
	return 1.-smoothstep(_radius-(_radius*blur),
                         _radius+(_radius*blur),
                         dot(dist,dist)*4.0);
}

// TV Effect

vec4 FADE_COLOR = vec4(0.006,0.007,0.010,1.000);
float BUFFER = 2.0;
float SCALE_SPEED = 1.5;

vec3 offImage(in vec2 fragCoord )
{
    float onePixelScale = (u_resolution.y - 1.0) / u_resolution.y;
    
    float i = 1.0;
    
    float time = mod((0.67 - 0.17*i) * 4.0, 1.0 / SCALE_SPEED + 1.0 + BUFFER * 2.0);
    time = clamp(time- BUFFER, 0.0, 1.0 / SCALE_SPEED + 1.0);
    
    float scaleTime = clamp(time * SCALE_SPEED, 0.0, onePixelScale);
    float fadeTime = clamp(time - onePixelScale / SCALE_SPEED, 0.0, 1.0);
        
	vec2 uv = fragCoord.xy / iResolution.xy;
    vec2 scaledUV = vec2(
        (uv.x - 0.5) * (1.0 - scaleTime) + 0.5,
        (uv.y - 0.5) / (1.0 - scaleTime) + 0.5
    );
    
	vec4 textureColor = texture2D(mTex, scaledUV) + vec4(scaleTime, scaleTime, scaleTime, 0);
    float fadeOutLevel = 1.0 - fadeTime;
    float cropPixel = min(
        clamp(
            sign(
                abs(scaleTime / 2.0 - 0.5) 
                - abs(uv.y - 0.5)
            )
            , 0.0, 1.0
        ), 
        clamp(
            sign(
                1.0 - fadeTime
                - abs(uv.x - 0.5)
            ),
            0.0, 
            1.0
        )
    );
    
    vec4 newColor = mix(
        FADE_COLOR, 
        mix(FADE_COLOR, textureColor, fadeOutLevel), 
        cropPixel
    );
    return newColor.xyz;
}

vec3 scanlineEffect(in vec3 color,in vec2 st,in float animVal){
    float scanlineIntesnsity = 0.125;
    float scanlineCount = 3000.0;
    float scanlineYDelta = sin(u_time / 200.0);
	float scanline = sin((st.y - scanlineYDelta) * scanlineCount) * scanlineIntesnsity;
    vec3 mCol = color;
    mCol -= scanline*animVal;
    return mCol;
}

void main() {
    
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    vec3 color = vec3(0.);
    //crop effect;
    //vec3 outImage = offImage(gl_FragCoord.xy);
    color = texture2D(mTex,st).xyz;
    
    //scanline Effect
	color = scanlineEffect(color,st,(1.-u_slot1)*u_slot1);
    //saturation Effect
    color = czm_saturation(color,u_slot1);
    //brightness Effect
    color = brightnessContrast(color,-1.+u_slot1,1.);
    

    //circle Mask Effect
    //color *= circle(st,0.5 + 4.*u_slot1,vec2(0.5,0. + 1.*min(0.5,u_slot1)),0.5+0.5*u_slot1);
	
    gl_FragColor = vec4(color,1.0);
}