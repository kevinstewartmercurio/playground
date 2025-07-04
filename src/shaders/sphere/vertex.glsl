uniform float uTime;
uniform float uAmplitude;

varying vec3 vReflect;

void main() {
    vec4 modelPosition = modelMatrix * vec4(position, 1.0);

    modelPosition.y += cos(modelPosition.x + uTime) * uAmplitude;
    modelPosition.z += sin(modelPosition.x + uTime) * uAmplitude;

    vec4 viewPosition = viewMatrix * modelPosition;
    vec4 projectedPosition = projectionMatrix * viewPosition;

    gl_Position = projectedPosition;

    vec3 worldNormal = normalize(mat3(modelMatrix) * normal);
    vec3 cameraToVertex = normalize(modelPosition.xyz - cameraPosition);
    vReflect = reflect(cameraToVertex, worldNormal);
}