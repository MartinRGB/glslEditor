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
uniform sampler2D u_tex14;
uniform sampler2D u_tex15;
varying vec2 v_texcoord;

uniform float u_slot1;
uniform float u_slot2;
#define pageturnDisplacement u_slot2

#define uResolution u_resoltuion
#define uTime u_time
#define texCoord v_texcoord
#define uTexture u_tex14

#define uSpaceScale 3.
#define uSpaceTranslate vec2(0.100,0.090)

#define uColorValue1 vec3(0.44,0.0,0.0)
#define uColorValue2 vec3(0.0, 0.86, 0.74)
#define uColorValue3 vec4(1.0,0.0,1.0,0.0)
#define uBrightness 0.95
#define uContrast 1.
#define uGamma 1.0
#define uSpeed 2.5

// vec3 brightnessContrast(in vec3 value,in float brightness)
// {
//     return value + brightness;
// }

vec3 brightnessContrast(vec3 value, float brightness, float contrast)
{
    return (value - 0.5) * contrast + 0.5 + brightness;
}

vec3 Gamma(vec3 value, float param)
{
    return vec3(pow(abs(value.r), param),pow(abs(value.g), param),pow(abs(value.b), param));
}

void main() {
    vec2 st =  vec2(texCoord.x*102./234.,texCoord.y - 1.)*uSpaceScale;
    st+=vec2(0.030,1.000)+uSpaceTranslate;
    vec3 color = vec3(0.0);


    vec2 q = vec2(0.);
    float texScale = 6.5;
    q.x = texture2D(uTexture, (st - 0.24*(u_time)*uSpeed) / texScale).x;
    q.y = texture2D(uTexture, (st + vec2(1.0) - 0.18*(u_time)*uSpeed) / texScale).y;
    q+= vec2(u_slot1*u_slot1*0.5 - 0.5  + pageturnDisplacement/5.  ,u_slot1*u_slot1*0.5 - 0.5);

    vec2 r = vec2(0.);
    r.x = texture2D(uTexture, (st + 1.0*q*u_slot1*u_slot1 + vec2(0.330,-0.660)*u_slot1*u_slot1 + 0.15*(u_time)*uSpeed + vec2(pageturnDisplacement/2.,0.)) / texScale).x;
    r.y = texture2D(uTexture, (st + 1.0*q*u_slot1*u_slot1 + vec2(0.140,-0.430)*u_slot1*u_slot1 + 0.126*(u_time)*uSpeed + vec2(pageturnDisplacement/2.,0.)) / texScale).y;
    r+= vec2(0.5-u_slot1*u_slot1*0.5 -  pageturnDisplacement/5.,u_slot1*u_slot1*0.5 - 0.5);
    
    float f = texture2D(uTexture, (st + r + pageturnDisplacement/5.) / texScale).x;
    float g = texture2D(uTexture, (st + r + pageturnDisplacement/5. ) / texScale).y;
    float h = texture2D(uTexture, (st + r ) / texScale).z;

    color = mix(vec3(st.x,uColorValue3.x,uColorValue3.y)*u_slot1*u_slot1, vec3(st.y,uColorValue3.z,uColorValue3.w)*u_slot1*u_slot1,clamp((f*f)*1.024,0.0,1.0));
    color = mix(color, uColorValue1, clamp(length(q), .0, 0.616));
    color = mix(color, uColorValue2, clamp(length(r.x), 0.0, 0.624));
    vec3 finalColor = (f * f * f + .6 * g + .5 * h) * color;
    finalColor.r = clamp(finalColor.r, 0.0, 1.0);
    finalColor = abs(brightnessContrast(finalColor, -uBrightness, uContrast));
    
    finalColor = Gamma(finalColor, uGamma);
    finalColor *= u_slot1;
    finalColor = smoothstep(vec3(0.),vec3(1.1),finalColor);
    gl_FragColor = vec4(finalColor, 1.);

}

