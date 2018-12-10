//Vetex

uniform mat4 uMVPMatrix;
attribute vec4 aPosition;
attribute vec2 aTextureCoord;
varying vec2 vTextureCoordNormal;
varying vec2 vTextureCoord;
varying vec2 vTextureCoordPUtime5;
uniform float u_time;
uniform float u_time5;
uniform float zoom;
uniform float extraZoom;
uniform float ratio;
uniform float offsetX;
uniform float offsetY;
uniform float qmul;
uniform float rmul;
uniform vec2 windDirection;
void main() {
   gl_Position = uMVPMatrix * aPosition;
   vTextureCoordNormal = aTextureCoord;
   vTextureCoordNormal.y = vTextureCoordNormal.y*ratio;
   vTextureCoord = aTextureCoord;
   vTextureCoord.y = vTextureCoord.y*ratio;
   vTextureCoord = vTextureCoord*zoom*extraZoom;
   vTextureCoord = vTextureCoord+(u_time*windDirection);
   vTextureCoord.y = vTextureCoord.y+(offsetX/2.0);
   vTextureCoord.x = vTextureCoord.x+(offsetY/2.0);
   vTextureCoordPUtime5 = vTextureCoord+u_time5;
}



// Frag 


precision highp float;
varying vec2 vTextureCoord;
varying vec2 vTextureCoordPUtime5;
varying vec2 vTextureCoordNormal;
uniform sampler2D uTexture0;
uniform vec3 gradColor1;
uniform vec3 gradColor2;
uniform vec3 gradColor3;
uniform vec3 gradColor4;
uniform vec3 gradColor5;
uniform vec3 gradColor6;
uniform vec2 pokePosition;
uniform float pokeSize;
uniform float qmul;
uniform float rmul;
uniform float u_time;
uniform float ratio;
vec3 getGradient1(in float posFloat) {
      float clampPos = clamp(posFloat, 0.01, 0.99);
  return clampPos*gradColor1+(1.0-clampPos)*gradColor2;
}
vec3 getGradient2(in float posFloat) {
      float clampPos = clamp(posFloat, 0.01, 0.99);
  return clampPos*gradColor3+(1.0-clampPos)*gradColor4;
}
vec3 getGradient3(in float posFloat) {
      float clampPos = clamp(posFloat, 0.01, 0.99);
  return clampPos*gradColor5+(1.0-clampPos)*gradColor6;
}

float pattern( out float q, out float r ) {
   q =    texture2D( uTexture0, vTextureCoord ).z;
   r =    texture2D( uTexture0, vTextureCoordPUtime5 + q*qmul ).y;
   return texture2D( uTexture0, vTextureCoordPUtime5 + r*rmul ).x;
 }

void main() {
   float q, r;
   float col = pattern(q, r);
   col=(col*r)*0.8+(r*q+r*q)*0.5;
   vec3 gradCol = getGradient1(col);
   gl_FragColor = vec4(gradCol.x, gradCol.y, gradCol.z, 1.0);
}
