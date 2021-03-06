// Author:
// Title:

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;
uniform sampler2D u_tex23;
uniform sampler2D u_tex21;
uniform vec2 u_tex0Resolution;
uniform float u_slot1;
uniform float u_slot2;
//Shader Toy Basic Uniform
#define iResolution u_resolution
#define iMouse u_mouse

#define u_noise_uvs_zoom = 1.3
#define u_noise_displacement 0.3
#define uTexture u_tex21
varying vec2 v_texcoord;

vec3 mod289(vec3 x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec2 mod289(vec2 x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec3 permute(vec3 x) {
  return mod289(((x*34.0)+1.0)*x);
}

float snoise(vec2 v)
  {
  const vec4 C = vec4(0.211324865405187,  // (3.0-sqrt(3.0))/6.0
                      0.366025403784439,  // 0.5*(sqrt(3.0)-1.0)
                     -0.577350269189626,  // -1.0 + 2.0 * C.x
                      0.024390243902439); // 1.0 / 41.0
// First corner
  vec2 i  = floor(v + dot(v, C.yy) );
  vec2 x0 = v -   i + dot(i, C.xx);

// Other corners
  vec2 i1;
  //i1.x = step( x0.y, x0.x ); // x0.x > x0.y ? 1.0 : 0.0
  //i1.y = 1.0 - i1.x;
  i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
  // x0 = x0 - 0.0 + 0.0 * C.xx ;
  // x1 = x0 - i1 + 1.0 * C.xx ;
  // x2 = x0 - 1.0 + 2.0 * C.xx ;
  vec4 x12 = x0.xyxy + C.xxzz;
  x12.xy -= i1;

// Permutations
  i = mod289(i); // Avoid truncation effects in permutation
  vec3 p = permute( permute( i.y + vec3(0.0, i1.y, 1.0 ))
		+ i.x + vec3(0.0, i1.x, 1.0 ));

  vec3 m = max(0.5 - vec3(dot(x0,x0), dot(x12.xy,x12.xy), dot(x12.zw,x12.zw)), 0.0);
  m = m*m ;
  m = m*m ;

// Gradients: 41 points uniformly over a line, mapped onto a diamond.
// The ring size 17*17 = 289 is close to a multiple of 41 (41*7 = 287)

  vec3 x = 2.0 * fract(p * C.www) - 1.0;
  vec3 h = abs(x) - 0.5;
  vec3 ox = floor(x + 0.5);
  vec3 a0 = x - ox;

// Normalise gradients implicitly by scaling m
// Approximation of: m *= inversesqrt( a0*a0 + h*h );
  m *= 1.79284291400159 - 0.85373472095314 * ( a0*a0 + h*h );

// Compute final noise value at P
  vec3 g;
  g.x  = a0.x  * x0.x  + h.x  * x0.y;
  g.yz = a0.yz * x12.xz + h.yz * x12.yw;
  return 130.0 * dot(m, g);
}

float blendColorDodge(float base, float blend) {
	return (blend==1.0)?blend:min(base/(1.0-blend),1.0);
}

vec3 blendColorDodge(vec3 base, vec3 blend) {
	return vec3(blendColorDodge(base.r,blend.r),blendColorDodge(base.g,blend.g),blendColorDodge(base.b,blend.b));
}

vec3 blendColorDodge(vec3 base, vec3 blend, float opacity) {
	return (blendColorDodge(base, blend) * opacity + base * (1.0 - opacity));
}


vec3 brightnessContrast(in vec3 value, in float brightness,in float contrast)
{
    value = ( value - 0.5 ) * contrast + 0.5 + brightness;

    return value;
}

vec3 czm_saturation(vec3 rgb, float adjustment)
{
    const vec3 W = vec3(0.2125, 0.7154, 0.0721);
    vec3 intensity = vec3(dot(rgb, W));
    return mix(intensity, rgb, adjustment);
}

void main() {
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    float s = snoise(vec2(st.x,st.y*1.3+u_time/4.));
    
    // multiply the uv coord for 1 + the noise
    st*= vec2( 1.0 + s * (0.3*u_slot1) );
    // apply page offset
    st.x += ( u_slot2 * 0.5 + 0.5 );
    
    vec3 color = texture2D(uTexture,vec2(st.x*108./234.,st.y)/1.5).xyz;
    
    color.rgb = blendColorDodge(
        color.rgb,
        mix( vec3( 0.0, 0.0, 0.0 ),
             vec3( 0.14, 0., 0.0),
             0.
        )
    );
    
    color.rgb = blendColorDodge(
        color.rgb,
        mix( vec3( 0.0, 0.0, 0.0 ),
             vec3(0.09, 0.08, 0.0),
             abs( sin( u_time ) )
        )
    );
    
    color = czm_saturation(color,u_slot1*0.8);
    //brightness Effect
    color = brightnessContrast(color,-1.+u_slot1,1.);
    


    gl_FragColor = vec4(color ,1.0);
}