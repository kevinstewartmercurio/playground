uniform samplerCube envMap;

varying vec3 vReflect;

void main() {
    // gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);

    vec4 envColor = textureCube(envMap, vReflect);
    gl_FragColor = envColor;
}