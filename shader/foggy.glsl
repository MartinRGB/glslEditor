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

#define uResolution u_resoltuion
#define uTime u_time
#define texCoord v_texcoord
#define uTexture u_tex1

// #define uSpaceScale 4.0
// #define uSpaceTranslate vec2(0.0)
// #define uBrightness 1.0
// #define uColorValue1 vec3(0.78,0.67,0.31)
// #define uColorValue2 vec3(0.52,0.11,0.5)
// #define uSpeed 2.0

uniform float uSpaceScale;
uniform vec2 uSpaceTranslate;
uniform float uBrightness;
uniform vec3 uColorValue1;
uniform vec3 uColorValue2;
uniform float uSpeed;

#define NUM_OCTAVES 8

float fbm ( in vec2 _st) {
    float v = 0.0;
    float a = 0.5;
    vec2 shift = vec2(100.0);
    // Rotate to reduce axial bias
    mat2 rot = mat2(cos(0.5), sin(0.5),
                    -sin(0.5), cos(0.50));
    for (int i = 0; i < NUM_OCTAVES; ++i) {
        v += a * texture2D(uTexture,_st/2000.).x;
        _st = rot * _st * (2.0) + shift;
        a *= 0.5;
    }
    return v;
}

vec3 brightnessContrast(vec3 value, float brightness)
{
    return value + brightness;
}

void main() {
    vec2 st = vec2(v_texcoord.x / 234.*108., (1.0 - v_texcoord.y)) * uSpaceScale; // ([0.0, 1.84], [4.0, 0.0])
    st.xy += uSpaceTranslate * uSpaceScale;

    vec3 color = vec3(0.0);

    float speed = 0.5;

    vec2 q = vec2(0.);
    q.x = fbm( st + 0.100*u_time);
    q.y = fbm( st + vec2(1.0));


    vec2 r = vec2(0.);
    float fluidFactor = 1.0;

    r.x = fbm( st + fluidFactor*q +  vec2(1.7,9.2) + 0.15*u_time*uSpeed);
    r.y = fbm( st + fluidFactor*q + vec2(8.3,2.8) + 0.126*u_time*uSpeed);

    float f = fbm(st+r);

    color = mix(vec3(st.x,(cos(u_time/5.)+1.)/2.,(sin(u_time/3.)+1.)/2.),
                vec3(st.y,(cos(u_time/10.)+1.)/2.,sin(u_time/8.)*cos(u_time/2.)),
                clamp((f*f)*4.0,0.0,1.0));


    color = mix(color,vec3(uColorValue1.x,uColorValue1.y,uColorValue1.z), clamp(length(q),0.0,1.0));

    color = mix(color, vec3(uColorValue2.x,uColorValue2.y,uColorValue2.z), clamp(length(r.x),0.0,1.0));

    color.r = clamp(color.r, 0.0, 1.0);
    vec3 finalColor = (f*f*f+.6*f*f+.5*f)*color+color*.2;
    finalColor.r = clamp(finalColor.r, 0.0, 1.0);
    finalColor = abs(brightnessContrast(finalColor, -uBrightness));
    gl_FragColor = vec4(finalColor, 1.);
}

