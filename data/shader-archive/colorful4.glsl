#ifdef GL_ES
precision highp float;
#endif

uniform vec2 u_resoltuion;
uniform float u_time;
uniform sampler2D u_tex0;
uniform sampler2D u_tex1;
uniform sampler2D u_tex2;
uniform sampler2D u_tex3;
uniform sampler2D u_tex4;
uniform sampler2D u_tex5;
uniform sampler2D u_tex6;
varying vec2 v_texcoord;
uniform float u_slot1;
uniform float u_slot2;

#define uResolution u_resoltuion
#define uTime u_time
#define texCoord v_texcoord
#define uTexture u_tex1

#define uSpaceScale 4.0
#define uSpaceTranslate vec2(0.0)

#define uColorValue1 vec3(0.76,0.66,0.0)
#define uColorValue2 vec3(0.0, 1.0, 0.99)
#define uColorValue3 vec4(0.0,0.0,0.0,0.0)
#define uBrightness 0.65
#define uSpeed 1.0

#define iChannel0 u_tex6

vec2 computeUV(in vec2 uv,in float k,in float kcube ){
    
    vec2 t = uv - .5;
    float r2 = t.x * t.x + t.y * t.y;
	float f = 0.;
    
    if( kcube == 0.0){
        f = 1. + r2 * k;
    }else{
        f = 1. + r2 * ( k + kcube * sqrt( r2 ) );
    }
    
    vec2 nUv = f * t + .5;
    nUv.y = 1. - nUv.y;
 
    return nUv;
    
}

vec3 brightnessContrast(in vec3 value,in float brightness)
{
    return value + brightness;
}

vec3 foggyComputer(in vec2 st){
    

    vec3 color = vec3(0.0);

    float noStop = 1.;

    vec2 translate1 = vec2(u_slot1*u_slot1*-1.5+0.980);
    vec2 translate2 = vec2(0.902-1.432*u_slot1*u_slot1,-1.070+0.482*u_slot1)*1.5;
    vec2 translate3 = vec2(u_slot1*u_slot1*1.056,u_slot1*u_slot1*-0.984 + 0.676);

    vec2 q = vec2(0.);
    float texScale = 5.5;
    q.x = texture2D(iChannel0, (st +  0.00 ) / texScale).x;
    q.y = texture2D(iChannel0, (st + vec2(1.0)*u_slot1*u_slot1) / texScale).y;

    vec2 r = vec2(0.);
    r.x = texture2D(iChannel0, (st + 1.0*q*u_slot1*u_slot1 + vec2(0.330,-0.660)*u_slot1*u_slot1 + 0.15*(u_time)*1.0 ) / texScale).x;
    r.y = texture2D(iChannel0, (st + 1.0*q*u_slot1*u_slot1 + vec2(0.140,-0.430)*u_slot1*u_slot1 + 0.126*(u_time)*1.0  ) / texScale).y;

    float f = texture2D(iChannel0, (st + r ) / texScale).x;
    float g = texture2D(iChannel0, (st + r ) / texScale).y;
    float h = texture2D(iChannel0, (st + r ) / texScale).z;

     color = mix(vec3(st.x, uColorValue3.x, uColorValue3.y)*u_slot1*u_slot1,
                   vec3(st.y, uColorValue3.z, uColorValue3.w)*u_slot1*u_slot1,
                   clamp((f * f) * 1.024, 0.0, 1.0));
     color = mix(color*u_slot1*u_slot1, uColorValue1*u_slot1*u_slot1, clamp(length(q), 0., 0.616));
     color = mix(color*u_slot1*u_slot1, uColorValue2*u_slot1*u_slot1, clamp(length(r.x), 0., 0.624));
     vec3 finalColor = (f * f * f + .6 * g + .5 * h) * color*u_slot1;
     finalColor.r = clamp(finalColor.r, 0.0, 0.7);
     finalColor.g = clamp(finalColor.g, 0.0, 0.5);
     finalColor = abs(brightnessContrast(finalColor, -uBrightness*u_slot1)) *(-0.5+1.5*u_slot1);
    
     return finalColor.xyz;
}


void main() {

     vec2 st =  vec2(texCoord.x,texCoord.y)*(1.5+0.5*u_slot1);
     st+= -vec2(0.5,0.)*u_slot1;
    
    vec3 finColor2 = foggyComputer(st);
    
     gl_FragColor = vec4(finColor2, 1.);

}

