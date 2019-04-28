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
uniform sampler2D u_tex7;
uniform sampler2D u_tex14;
uniform sampler2D u_tex15;
varying vec2 v_texcoord;

uniform float u_slot1;
uniform float u_slot2;

#define uResolution u_resoltuion
#define uTime u_time
#define texCoord v_texcoord
#define uTexture u_tex6

#define uSpaceScale 3.076
#define uSpaceTranslate vec2(51.,51.)*0.456
#define uColors vec4(1.,1.,1.,1.)
#define uColorValue1 vec3(1.000,0.51,0.0)
#define uColorValue2 vec3(0.22,0.51,0.640)
#define uBrightness 0.8
#define uGamma 1.0
#define uContrast 1.51
#define uSpeed 1.2
#define pageturnDisplacement u_slot2



vec3 brightnessContrast(vec3 value, float brightness, float contrast)
{
    return (value - 0.5) * contrast + 0.5 + brightness;
}

vec3 Gamma(vec3 value, float param)
{
    return vec3(pow(abs(value.r), param),pow(abs(value.g), param),pow(abs(value.b), param));
}

float noise( in vec2 x )
{
	return sin(1.5*x.x)*sin(1.5*x.y);
}

void main() {
    vec2 st =  vec2(v_texcoord.x*92./234.,v_texcoord.y)*uSpaceScale;
    st+= vec2(0.000,.980)*18.528;
    st+= uSpaceTranslate + vec2(pageturnDisplacement/4.,0.);;
    //st += uSpaceTranslate + vec2(0., 0.49) + - vec2(0,-0.43);
    vec3 color = vec3(0.0);
    float speed = 0.5;

    vec2 q = vec2(0.);
    float texScale = 5.5;
    q.x = texture2D(uTexture, (st + 0.00*u_time ) / texScale).x;
    q.y = texture2D(uTexture, (st + vec2(1.0)) / texScale).y;
    q+= vec2(u_slot1*u_slot1*0.5 - 0.5  + pageturnDisplacement/5.  ,u_slot1*u_slot1*0.5 - 0.5);

    vec2 r = vec2(0.);
    r.x = texture2D(uTexture, (st + 1.0*q*u_slot1*u_slot1 + vec2(-0.330,-0.660)*u_slot1*u_slot1+ 0.25*(u_time)* uSpeed + vec2(pageturnDisplacement/2.,0.)) / texScale).x;
    r.y = texture2D(uTexture, (st + 1.0*q*u_slot1*u_slot1 + vec2(-0.140,-0.430)*u_slot1*u_slot1+ 0.226*(u_time)* uSpeed + vec2(pageturnDisplacement/2.,0.)) / texScale).y;
    r+= vec2(0.5-u_slot1*u_slot1*0.5 -  pageturnDisplacement/5.,u_slot1*u_slot1*0.5 - 0.5);

    float f = texture2D(uTexture, (st + r + pageturnDisplacement/5.) / texScale).x;
    float g = texture2D(uTexture, (st + r + pageturnDisplacement/5.) / texScale).y;
    float h = texture2D(uTexture, (st + r ) / texScale).z;

    color = mix(vec3(st.x,uColors.x,uColors.y)*u_slot1*u_slot1, vec3(st.y,uColors.z,uColors.w)*u_slot1*u_slot1,clamp((f*f)*1.024,0.0,1.0));

    color = mix(color,uColorValue1,clamp(length(q), 0.9, 0.616));

    color = mix(color,uColorValue2,clamp(length(r.x), 0.5, 0.624));

    color = smoothstep(vec3(0.),vec3(1.2),color);

    vec3 finColor = (f*f*f+.6*g+.5*h)*color*u_slot1;

    finColor.r = clamp(finColor.r, 0.0, 0.7);
    finColor.g = clamp(finColor.g, 0.0, 0.9);
    
    finColor = brightnessContrast(finColor, -uBrightness, uContrast);
    finColor = Gamma(finColor, uGamma);
    
    gl_FragColor = vec4(finColor,1.0);
    //gl_FragColor = texture2D(uTexture, vec2(v_texcoord.x*92./234.,v_texcoord.y));

}

