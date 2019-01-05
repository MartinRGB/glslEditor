// Author:
// Title:

#ifdef GL_ES
precision highp float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;
uniform sampler2D u_tex7;
uniform sampler2D u_tex1;
uniform vec2 u_tex0Resolution;
uniform vec2 u_tex10Resolution;
uniform vec2 u_tex7Resolution;
uniform float u_slot1;
uniform float u_slot2;
//Shader Toy Basic Uniform
#define uBrightness 0.0
#define uContrast 0.000
#define uGamma 0.0
#define uSpeed 1.5


vec2 rotateUvs(vec2 uv, float a)
{
   float s = sin ( a );
   float c = cos ( a );
   mat2 m = mat2( c, -s, s, c);
   return m * uv;
}

float gradientNoise(in vec2 uv)
{
   const vec3 magic = vec3(0.06711056, 0.00583715, 52.9829189);
   return fract(magic.z * fract(dot(uv, magic.xy)));
}

vec3 brightnessContrast(vec3 value, float brightness, float contrast)
{
    return (value - 0.5) * contrast + 0.5 + brightness;
}

vec3 Gamma(vec3 value, float param)
{
    return vec3(pow(abs(value.r), param),pow(abs(value.g), param),pow(abs(value.b), param));
}

#define SRGB_TO_LINEAR(c) pow((c), vec3(2.2))
#define LINEAR_TO_SRGB(c) pow((c), vec3(1.0 / 2.2))
#define SRGB(r, g, b) SRGB_TO_LINEAR(vec3(float(r), float(g), float(b)) / 255.0)

const vec3 COLOR_BOTTOM = SRGB(255, 0, 114);
const vec3 COLOR_TOP = SRGB(197, 255, 80);


float cheapstep(float x)
{
    x = 1.0 - x*x;	// MAD
    x = 1.0 - x*x;	// MAD
    return x;
}


void main() {
   vec2 st = gl_FragCoord.xy/u_resolution.xy ;
    
    // vec2 bPo = vec2(0.,0.-0.1*(sin(u_time*uSpeed) + 1.)); // First gradient point.
    // vec2 tPo = vec2(0.0,1.+0.1*(cos(u_time*uSpeed/2.) + 1.)); // Second gradient point
    
    vec2 bPo = vec2((cos(u_time*uSpeed) + 1.)/5.,0.-0.2*(sin(u_time*uSpeed) + 1.)); 
    vec2 tPo = vec2((sin(u_time*uSpeed) + 1.)/5.,1.+0.2*(cos(u_time*uSpeed/2.) + 1.)); 
    
    vec3 COLOR_BOTTOM;
    vec3 COLOR_TOP;
    vec3 COLOR_BOTTOM_MIX;
    vec3 COLOR_TOP_MIX;
    
    float timeStep = 1.*u_slot1;
    
    if(mod(floor(timeStep),6.) == 0.){

        COLOR_BOTTOM = SRGB(255, 251, 241);
        COLOR_TOP = SRGB(47, 109, 218);
        
        if(fract(timeStep) < 0.5 ){
         	COLOR_BOTTOM_MIX = SRGB(52, 67, 105);
        	COLOR_TOP_MIX = SRGB(14, 21, 46);
        }
        else{
            COLOR_BOTTOM_MIX = SRGB(251, 255, 196);
            COLOR_TOP_MIX = SRGB(0, 190, 223);
        }
    }
    else if(mod(floor(timeStep),6.) == 1.){
        COLOR_BOTTOM = SRGB(251, 255, 196);
        COLOR_TOP = SRGB(0, 190, 223);
        
        if(fract(timeStep) < 0.5 ){
         	COLOR_BOTTOM_MIX = SRGB(255, 251, 241);
        	COLOR_TOP_MIX = SRGB(47, 109, 218);
        }
        else{
            COLOR_BOTTOM_MIX = SRGB(71, 189, 251);
            COLOR_TOP_MIX = SRGB(15, 42, 150);
        }
    }
    else if(mod(floor(timeStep),6.) == 2.){
        COLOR_BOTTOM = SRGB(71, 189, 251);
        COLOR_TOP = SRGB(15, 42, 150);
        
        if(fract(timeStep) < 0.5 ){
         	COLOR_BOTTOM_MIX = SRGB(251, 255, 196);
        	COLOR_TOP_MIX = SRGB(0, 190, 223);
        }
        else{
            COLOR_BOTTOM_MIX = SRGB(250, 232, 216);
            COLOR_TOP_MIX = SRGB(49, 34, 203);
        }
    }
    else if(mod(floor(timeStep),6.) == 3.){
        COLOR_BOTTOM = SRGB(250, 232, 216);
        COLOR_TOP = SRGB(49, 34, 203);
        
        if(fract(timeStep) < 0.5 ){
         	COLOR_BOTTOM_MIX = SRGB(71, 189, 251);
        	COLOR_TOP_MIX = SRGB(15, 42, 150);
        }
        else{
            COLOR_BOTTOM_MIX = SRGB(127, 99, 184);
            COLOR_TOP_MIX = SRGB(15, 38, 135);
        }
    }
    else if(mod(floor(timeStep),6.) == 4.){
        COLOR_BOTTOM = SRGB(127, 99, 184);
        COLOR_TOP = SRGB(15, 38, 135);
        
        if(fract(timeStep) < 0.5 ){
         	COLOR_BOTTOM_MIX = SRGB(250, 232, 216);
        	COLOR_TOP_MIX = SRGB(49, 34, 203);
        }
        else{
            COLOR_BOTTOM_MIX = SRGB(52, 67, 105);
            COLOR_TOP_MIX = SRGB(14, 21, 46);
        }
    }
    
    else if(mod(floor(timeStep),6.) == 5.){
        COLOR_BOTTOM = SRGB(52, 67, 105);
        COLOR_TOP = SRGB(14, 21, 46);
        
        if(fract(timeStep) < 0.5 ){
         	COLOR_BOTTOM_MIX = SRGB(127, 99, 184);
        	COLOR_TOP_MIX = SRGB(15, 38, 135);
        }
        else{
            COLOR_BOTTOM_MIX = SRGB(255, 251, 241);
            COLOR_TOP_MIX = SRGB(47, 109, 218);
        }
    }
    
    else{

        COLOR_BOTTOM = SRGB(255, 251, 241);
        COLOR_TOP = SRGB(47, 109, 218);
        
        if(fract(timeStep) < 0.5 ){
         	COLOR_BOTTOM_MIX = SRGB(52, 67, 105);
        	COLOR_TOP_MIX = SRGB(14, 21, 46);
        }
        else{
            COLOR_BOTTOM_MIX = SRGB(251, 255, 196);
            COLOR_TOP_MIX = SRGB(0, 190, 223);
        }
    }
    
    vec2 bt = tPo - bPo;
   
    float t = dot(st - bPo, bt) / dot(bt, bt);
    t = smoothstep(0.0, 1.0, clamp(t, 0.0, 1.0));
    //t = cheapstep(t);
    vec3 calcColor = mix(COLOR_BOTTOM, COLOR_TOP, t);
	calcColor = LINEAR_TO_SRGB(calcColor);
    
    
    vec3 calcColorMix = mix(COLOR_BOTTOM_MIX,COLOR_TOP_MIX, t);
	calcColorMix = LINEAR_TO_SRGB(calcColorMix);
    
    calcColor = mix(calcColor,calcColorMix,(1. - fract(timeStep)) );

    float noise = texture2D(u_tex1,gl_FragCoord.xy/u_resolution.yy*14.).r;
    //color.rgb += mix(-0.5/255.0, 0.5/255.0, noise);
    
    calcColor = brightnessContrast(calcColor,0.-uBrightness,1.0 + uContrast);
    calcColor = Gamma(calcColor,0.9+ uGamma); 
    calcColor.rgb += mix(-1.5/255.0, 1.5/255., noise);

   gl_FragColor = vec4(calcColor,1.0);
}