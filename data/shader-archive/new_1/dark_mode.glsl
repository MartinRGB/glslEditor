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
uniform sampler2D u_tex23;
uniform vec2 u_tex0Resolution;
uniform float u_slot1;
uniform float u_slot2;
varying vec2 v_texcoord;

//Shader Toy Basic Uniform
#define iTime u_time
#define iResolution u_resolution
#define iMouse u_mouse
#define mTex u_tex23

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

vec3 rgb2hsb( in vec3 c ){
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), 
                 vec4(c.gb, K.xy), 
                 step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), 
                 vec4(c.r, p.yzx), 
                 step(p.x, c.r));
    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), 
                d / (q.x + e), 
                q.x);
}

vec3 hsb2rgb( in vec3 c ){
    vec3 rgb = clamp(abs(mod(c.x*6.0+vec3(0.0,4.0,2.0),
                             6.0)-3.0)-1.0, 
                     0.0, 
                     1.0 );
    rgb = rgb*rgb*(3.0-2.0*rgb);
    return c.z * mix( vec3(1.0), rgb, c.y);
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
    
    vec2 st = vec2(v_texcoord.x,v_texcoord.y);
    vec3 color = vec3(0.);
    //crop effect;
    //vec3 outImage = offImage(gl_FragCoord.xy);
    color = texture2D(mTex,st).xyz;
    
    //scanline Effect
	color = scanlineEffect(color,st,0.);
    //saturation Effect
    color = czm_saturation(color,1.);
    //brightness Effect
    color = brightnessContrast(color,0.,1.);
    

    color = rgb2hsb(color);
    
    float circle = circle(st,5.5 + 5.5*u_slot1,vec2(0.5,-1. + 1.5*u_slot1),0.5);
    
	if(color.g > 0.5){
		//color.z = color.z - (2.*color.z - 1.)*u_slot1*circle;
	}
	else if(color.r+color.g+color.b < 0.0){
		//color += 0.5;
	}
	else{
		color.z = color.z - (2.*color.z - 1.)*u_slot1*circle;
	}
    
    //color.r = sin(u_time/2.);
    
    color = hsb2rgb(color);
    
    vec3 mTex2 = texture2D(u_tex18,st).xyz;
    //circle Mask Effect
    //color *= circle(st,0.5 + 4.*u_slot1,vec2(0.5,0. + 1.*min(0.5,u_slot1)),0.5+0.5*u_slot1);
    
	// Circle Transition
    //gl_FragColor = vec4(color*(1.-circle) + mTex2 * circle,1.0
    gl_FragColor = vec4(color,1.0);
}