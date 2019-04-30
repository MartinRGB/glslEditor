 // Author:
// Title:

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;
uniform sampler2D u_tex23;
uniform sampler2D u_tex19;
uniform sampler2D u_tex20;
uniform sampler2D u_tex21;
uniform vec2 u_tex0Resolution;
uniform float u_slot1;
uniform float u_slot2;
varying vec2 v_texcoord;
//Shader Toy Basic Uniform
#define iTime u_time
#define iResolution u_resolution
#define iMouse u_mouse
#define uTexture u_tex20


vec3 brightnessContrast(in vec3 value, in float brightness,in float contrast)
{
    value = ( value - 0.5 ) * contrast + 0.5 + brightness;

    return value;
}

// void make_kernel(inout vec4 n[9], sampler2D tex, vec2 coord)
// {
// 	float w = 1.0 / 1080.;
// 	float h = 1.0 / 2340.;

// 	n[0] = texture2D(u_tex0, coord + vec2( -w, -h));
// 	n[1] = texture2D(u_tex0, coord + vec2(0.0, -h));
// 	n[2] = texture2D(u_tex0, coord + vec2(  w, -h));
// 	n[3] = texture2D(u_tex0, coord + vec2( -w, 0.0));
// 	n[4] = texture2D(u_tex0, coord);
// 	n[5] = texture2D(u_tex0, coord + vec2(  w, 0.0));
// 	n[6] = texture2D(u_tex0, coord + vec2( -w, h));
// 	n[7] = texture2D(u_tex0, coord + vec2(0.0, h));
// 	n[8] = texture2D(u_tex0, coord + vec2(  w, h));

//     float brightness = 2.0;
//     float contrast = 5.0;

// 	brightnessContrast(n[0].rgb, brightness, contrast);
// 	brightnessContrast(n[1].rgb, brightness, contrast);
// 	brightnessContrast(n[2].rgb, brightness, contrast);
// 	brightnessContrast(n[3].rgb, brightness, contrast);
// 	brightnessContrast(n[4].rgb, brightness, contrast);
// 	brightnessContrast(n[5].rgb, brightness, contrast);
// 	brightnessContrast(n[6].rgb, brightness, contrast);
// 	brightnessContrast(n[7].rgb, brightness, contrast);
// 	brightnessContrast(n[8].rgb, brightness, contrast);
// }


void main() {
    vec4 n[9];
    
    float w = 1.0 / 1080.;
	float h = 1.0 / 2340.;

	n[0] = texture2D(uTexture, v_texcoord + vec2( -w, -h));
	n[1] = texture2D(uTexture, v_texcoord + vec2(0.0, -h));
	n[2] = texture2D(uTexture, v_texcoord + vec2(  w, -h));
	n[3] = texture2D(uTexture, v_texcoord + vec2( -w, 0.0));
	n[4] = texture2D(uTexture, v_texcoord);
	n[5] = texture2D(uTexture, v_texcoord + vec2(  w, 0.0));
	n[6] = texture2D(uTexture, v_texcoord + vec2( -w, h));
	n[7] = texture2D(uTexture, v_texcoord + vec2(0.0, h));
	n[8] = texture2D(uTexture, v_texcoord + vec2(  w, h));

    float brightness = 2.0;
    float contrast = 5.0;

	n[0].xyz = brightnessContrast(n[0].rgb, brightness, contrast);
	n[1].xyz = brightnessContrast(n[1].rgb, brightness, contrast);
	n[2].xyz = brightnessContrast(n[2].rgb, brightness, contrast);
	n[3].xyz = brightnessContrast(n[3].rgb, brightness, contrast);
	n[4].xyz = brightnessContrast(n[4].rgb, brightness, contrast);
	n[5].xyz = brightnessContrast(n[5].rgb, brightness, contrast);
	n[6].xyz = brightnessContrast(n[6].rgb, brightness, contrast);
	n[7].xyz = brightnessContrast(n[7].rgb, brightness, contrast);
	n[8].xyz = brightnessContrast(n[8].rgb, brightness, contrast);

	vec4 sobel_edge_h = n[2] + (2.0*n[5]) + n[8] - (n[0] + (2.0*n[3]) + n[6]);
  	vec4 sobel_edge_v = n[0] + (2.0*n[1]) + n[2] - (n[6] + (2.0 *n[7]) + n[8]);
	vec4 sobel = sqrt((sobel_edge_h * sobel_edge_h) + (sobel_edge_v * sobel_edge_v));

    vec3 s = 1.0 - sobel.rgb;

	//brightnessContrast(s.rgb, 1.5, 3.0);

    vec3 col1 = vec3(step(0.1, sobel.r));
    vec3 col2 = texture2D(uTexture,v_texcoord).xyz;
    // gl_FragColor = vec4(col1,1.0);
    // gl_FragColor = vec4(col2,1.0);
}