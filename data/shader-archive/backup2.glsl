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

void main() {
    vec2 st =  vec2(v_texcoord.x/234.*108.,v_texcoord.y)*4.;
    vec3 color = vec3(0.0);


    vec2 q = vec2(0.);
    float texScale = 5.812;
    q.x = texture2D(u_tex5, (st + 0.00*u_time ) / texScale).x;
    q.y = texture2D(u_tex5, (st + vec2(1.0)) / texScale).y;

    vec2 r = vec2(0.);
    r.x = texture2D(u_tex5, (st + 1.0*q + vec2(-0.330,-0.660)+ 0.15*sin(u_time)) / texScale).x;
    r.y = texture2D(u_tex5, (st + 1.0*q + vec2(-0.140,-0.430)+ 0.126*cos(u_time)) / texScale).y;

    float f = texture2D(u_tex5, (st + r ) / texScale).x;
    float g = texture2D(u_tex5, (st + r  ) / texScale).y;
    float h = texture2D(u_tex5, (st + r ) / texScale).z;


    color = mix(vec3(st.x,cos(u_time/10.),sin(u_time/10.)),
                vec3(st.y,sin(u_time/10.),sin(u_time/10.)*cos(u_time/10.)),
                clamp((f*f)*4.0,0.0,1.0));

    color = mix(color,
                vec3(0,0,0.164706),
                clamp(length(q),.0,1.0));

    color = mix(color,
                vec3(0.666667,1,1),
                clamp(length(r.x),0.0,1.0));

    gl_FragColor = vec4((f*f*f*0.5+.6*g+.5*h)*color,1.);
}

