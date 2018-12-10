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
uniform float u_slot1;
varying vec2 v_texcoord;

void main() {
    vec2 st =  vec2(v_texcoord.x,v_texcoord.y)*4.;
    vec2 st2 =  vec2(1. - v_texcoord.x,v_texcoord.y)*3.960;
    vec2 st3 =  vec2(v_texcoord.x,1.-v_texcoord.y)*4.;
    vec3 color = vec3(0.0);
    
    float noStop = 1.;

    vec2 translate1 = vec2(u_slot1*-1.5+0.980);
    vec2 translate2 = vec2(0.902-1.432*u_slot1,-1.070+0.482*u_slot1)*1.5;
    vec2 translate3 = vec2(u_slot1*1.056,u_slot1*-0.984 + 0.676);

    //-0.74,-0.29
    vec2 q1 = vec2(0.);
    float texScale = 5.5;
    q1.x = texture2D(u_tex6, (st + 0.00*u_time ) / texScale).x;
    q1.y = texture2D(u_tex6, (st + vec2(-0.430,-0.040)*u_slot1) / texScale).y;
    q1 += vec2(translate1);
    
    vec2 r1 = vec2(0.);
    r1.x = texture2D(u_tex6, (st + 1.0*q1*u_slot1 + vec2(0.390,0.410)*u_slot1+ 0.15*sin(u_time*noStop)*u_slot1) / texScale).x;
    r1.y = texture2D(u_tex6, (st + 1.0*q1*u_slot1 + vec2(0.070,0.190)*u_slot1+ 0.126*cos(u_time*noStop)*u_slot1) / texScale).y;
    r1 += vec2(translate1);
    
    
    vec2 q2 = vec2(-0.);
    q2.x = texture2D(u_tex6, (st2 + 0.00*u_time ) / texScale).x;
    q2.y = texture2D(u_tex6, (st2 + vec2(-0.340,0.150)*u_slot1) / texScale).y;
    q2 += vec2(translate2);

    vec2 r2 = vec2(0.);
    r2.x = texture2D(u_tex6, (st2 + 1.0*q2*u_slot1 + vec2(-0.490,0.490)*u_slot1+ 0.15*sin(u_time*noStop)*(4.-u_slot1)) / texScale).x;
    r2.y = texture2D(u_tex6, (st2 + 1.0*q2*u_slot1 + vec2(-0.290,0.290)*u_slot1+ 0.126*cos(u_time*noStop)*(4.-u_slot1)) / texScale).y;
    r2 += vec2(translate2);
    
    vec2 q3 = vec2(-0.);
    q3.x = texture2D(u_tex6, (st3 + 0.00*u_time ) / texScale).x;
    q3.y = texture2D(u_tex6, (st3 + vec2(-0.030,0.280)) / texScale).y;
    q3 += vec2(translate2);

    vec2 r3 = vec2(0.);
    r3.x = texture2D(u_tex6, (st3 + 1.0*q3 + vec2(-0.220,0.250) + 0.15*sin(u_time*noStop)*(2.-u_slot1)) / texScale).x;
    r3.y = texture2D(u_tex6, (st3 + 1.0*q3 + vec2(0.090,0.960) + 0.126*cos(u_time*noStop)*(2.-u_slot1)) / texScale).y;
    r3 += vec2(translate3);

    float f = texture2D(u_tex6, (st + r1 ) / texScale).x ;
    float g = texture2D(u_tex6, ( st2 + r2) / texScale).y;
    float h = texture2D(u_tex6, (st3 + r3 ) / texScale).z;


    vec3 colorf1 = mix(vec3(st.x,cos(u_time*noStop/10.),sin(u_time*noStop/10.)),
                vec3(st.y,sin(u_time*noStop/10.),sin(u_time/10.)*cos(u_time*noStop/10.)),
                clamp((f*f)*4.0,0.0,1.0));

    vec3 colorf2 = mix(colorf1,
                vec3(0.850,0.838,0.617)*u_slot1,
                clamp(length(q1),.0,1.0));

    vec3 colorf3 = mix(colorf2,
            vec3(0.),
            clamp(length(r1.x),0.,1.0));
    
    vec3 colorg1 = mix(vec3(st.x,cos(u_time*noStop/10.),sin(u_time*noStop/10.)),
                vec3(st.y,sin(u_time*noStop/10.),sin(u_time*noStop/10.)*cos(u_time*noStop/10.)),
                clamp((g*g)*4.0,0.0,1.0));

    vec3 colorg2 = mix(colorg1,
                vec3(0.452,0.195,0.995)*u_slot1,
                clamp(length(q2),.0,0.896));
    
    vec3 colorg3 = mix(colorg2,
                vec3(0.),
                clamp(length(r2.y),0.,1.0));
    
    vec3 colorh1 = mix(vec3(st.x,cos(u_time*noStop/10.),sin(u_time*noStop/10.)),
                vec3(st.y,sin(u_time*noStop/10.),sin(u_time*noStop/10.)*cos(u_time*noStop/10.)),
                clamp((h*h)*4.0,0.0,0.0));

    vec3 colorh2 = mix(colorh1,
                vec3(0.097,0.006,0.165)*u_slot1,
                clamp(length(q3),.0,1.0));
    
    vec3 colorh3 = mix(colorh2,
                vec3(0.),
                clamp(length(r3.y),0.,1.0));

    vec3 finCol =  f*f*f*0.5*colorf3 + g*0.6*colorg3 +  h*h*h*h*colorh3   ; 
    
    gl_FragColor = vec4(finCol,1.);
}

