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

#define uResolution u_resoltuion
#define uTime u_time
#define texCoord v_texcoord
#define uTexture u_tex1

#define uSpaceScale 4.080
#define uSpaceTranslate vec2(-0.310,0.170)
#define uColors vec4(0.,0.,0.,0.)
#define uColorValue1 vec3(0.440,0.241,0.182)
#define uColorValue2 vec3(0.0, 0.86, 1.0)
#define uBrightness 0.65
#define uSpeed 1.0



vec3 brightnessContrast(in vec3 value,in float brightness)
{
    return value + brightness;
}

void main() {
    vec2 st =  vec2(v_texcoord.x,v_texcoord.y)*4.;
    st+= uSpaceTranslate;
    vec3 color = vec3(0.0);
    float speed = 0.5;
    
    vec2 translate1 = vec2(u_slot1*u_slot1-1.5+0.980);
    vec2 translate2 = vec2(0.902-1.432*u_slot1*u_slot1,-1.070+0.482*u_slot1*u_slot1)*1.5;
    vec2 translate3 = vec2(u_slot1*u_slot1*1.056,u_slot1*u_slot1-0.984 + 0.676);

    vec2 q = vec2(0.);
    float texScale = 5.5;
    q.x = texture2D(u_tex5, (st + 0.00*u_time ) / texScale).x;
    q.y = texture2D(u_tex5, (st + vec2(1.0)) / texScale).y;
    q+= vec2(u_slot1*0.5 - 0.5 ,u_slot1*0.5 - 0.5) ;

    vec2 r = vec2(0.);
    r.x = texture2D(u_tex5, (st + 1.0*q + vec2(-0.330,-0.660)+ 0.15*sin(u_time)*uSpeed) / texScale).x;
    r.y = texture2D(u_tex5, (st + 1.0*q + vec2(-0.140,-0.430)+ 0.126*cos(u_time)*uSpeed) / texScale).y;
    //r+= translate2;
    // r+= vec2(u_slot1*0.5-0.5,0.);
    r+= vec2(0.5-u_slot1*0.5,u_slot1*0.5 - 0.5) ;

    float f = texture2D(u_tex5, (st + r  ) / texScale).x ;
    float g = texture2D(u_tex5, (st + r  ) / texScale).y;
    float h = texture2D(u_tex5, (st + r ) / texScale).z;

    color = mix(vec3(st.x,uColors.x,uColors.y), vec3(st.y,uColors.z,uColors.w),clamp((f*f)*1.024,0.0,1.0));

    color = mix(color,
                vec3(uColorValue1.x,uColorValue1.y,uColorValue1.z),
                clamp(length(q),0.9,0.616));

    color = mix(color,
                vec3(uColorValue2.x,uColorValue2.y,uColorValue2.z),
                clamp(length(r.x),0.,.624));

    vec3 finColor = (f*f*f+.6*g+.5*h)*color;
    //finColor = texture2D(u_tex5,st/4.).xyz;
    
    gl_FragColor = vec4(finColor,1.0);

}

