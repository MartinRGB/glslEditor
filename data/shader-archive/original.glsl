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

#define uSpaceScale 4.0
#define uSpaceTranslate vec2(0.0)

#define uColorValue1 vec3(0.0,0.0,0.0)
#define uColorValue2 vec3(0.0, 1.0, 0.99)
#define uColorValue3 vec4(0.0,0.0,0.0,0.0)
#define uBrightness 0.65
#define uSpeed 1.0

vec3 brightnessContrast(in vec3 value,in float brightness)
{
    return value + brightness;
}

void main() {
    vec2 st =  vec2(texCoord.x,texCoord.y)*4.;
//    vec2 st =  vec2(texCoord.x/234.*108./234.*108.,(1.0-texCoord.y/234.*108.))*4.;
    vec3 color = vec3(0.0);
    float speed = 0.5;


    vec2 q = vec2(0.);
    float texScale = 5.5;
    q.x = texture2D(u_tex6, (st +  0.00 ) / texScale).x;
    q.y = texture2D(u_tex6, (st + vec2(1.0)) / texScale).y;

    vec2 r = vec2(0.);
    r.x = texture2D(u_tex6, (st + 1.0*q + vec2(0.330,-0.660) + 0.15*(u_time)*1.0) / texScale).x;
    r.y = texture2D(u_tex6, (st + 1.0*q + vec2(0.140,-0.430) + 0.126*(u_time)*1.0) / texScale).y;

    float f = texture2D(u_tex6, (st + r ) / texScale).x;
    float g = texture2D(u_tex6, (st + r  ) / texScale).y;
    float h = texture2D(u_tex6, (st + r ) / texScale).z;

     color = mix(vec3(st.x, uColorValue3.x, uColorValue3.y),
                   vec3(st.y, uColorValue3.z, uColorValue3.w),
                   clamp((f * f) * 1.024, 0.0, 1.0));
     color = mix(color, uColorValue1, clamp(length(q), .0, 0.616));
     color = mix(color, uColorValue2, clamp(length(r.x), 0.0, 0.624));
     vec3 finalColor = (f * f * f + .6 * g + .5 * h) * color;
     finalColor.r = clamp(finalColor.r, 0.0, 1.0);
     finalColor = abs(brightnessContrast(finalColor, -uBrightness));
     gl_FragColor = vec4(finalColor, 1.);

}

