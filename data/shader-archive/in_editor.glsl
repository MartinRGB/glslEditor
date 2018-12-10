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
#define uSpaceTranslate vec2(-0.310,0.170)
#define uColor1 vec2(0.)
#define uColor2 vec2(0.)
#define uColorValue1 vec3(0.44,0.0,0.0)
#define uColorValue2 vec3(0.0, 0.86, 1.0)
#define uBrightness 0.65
#define uSpeed 1.0



vec3 brightnessContrast(in vec3 value,in float brightness)
{
    return value + brightness;
}

void main() {
    vec2 st =  vec2(v_texcoord.x,v_texcoord.y)*uSpaceScale;
    st+= uSpaceTranslate;
    vec3 color = vec3(0.0);
    float speed = 0.5;

    vec2 q = vec2(0.);
    float texScale = 5.5;
    q.x = texture2D(u_tex5, (st + 0.00*u_time ) / texScale).x;
    q.y = texture2D(u_tex5, (st + vec2(1.0)) / texScale).y;

    vec2 r = vec2(0.);
    r.x = texture2D(u_tex5, (st + 1.0*q + vec2(-0.330,-0.660)+ 0.15*sin(u_time)*uSpeed) / texScale).x;
    r.y = texture2D(u_tex5, (st + 1.0*q + vec2(-0.140,-0.430)+ 0.126*cos(u_time)*uSpeed) / texScale).y;

    float f = texture2D(u_tex5, (st + r ) / texScale).x;
    float g = texture2D(u_tex5, (st + r  ) / texScale).y;
    float h = texture2D(u_tex5, (st + r ) / texScale).z;

    color = mix(vec3(st.x,uColor1.x/100.,uColor1.y/100.), vec3(st.y,uColor2.x/100.,uColor2.y/100.),clamp((f*f)*1.024,0.0,1.0));

    color = mix(color,
                vec3(uColorValue1.x,uColorValue1.y,uColorValue1.z),
                clamp(length(q),.0,0.616));

    color = mix(color,
                vec3(uColorValue2.x,uColorValue2.y,uColorValue2.z),
                clamp(length(r.x),0.0,0.624));

    vec3 finColor = (f*f*f+.6*g+.5*h)*color;
    gl_FragColor = vec4(finColor,1.0);

}

