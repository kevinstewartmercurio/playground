// https://www.shadertoy.com/view/dsXyzf

uniform float uTime;
uniform vec2 uResolution;
uniform vec3 uColorA;
uniform vec3 uColorB;

const float arrow_density = 4.5;
const float arrow_length = .45;

const int iterationTime1 = 15;
const int iterationTime2 = 15;
const int vector_field_mode = 0;
const float scale = 5.0;

const float velocity_x = 0.1;
const float velocity_y = 0.2;

const float mode_2_speed = 2.5;
const float mode_1_detail = 200.;
const float mode_1_twist = 50.;

float f(in vec2 p)
{
    return sin(p.x+sin(p.y+uTime*velocity_x)) * sin(p.y*p.x*0.1+uTime*velocity_y);
}


struct Field {
    vec2 vel;
    vec2 pos;
};

//---------------Field to visualize defined here-----------------

Field field(in vec2 p)
{
    Field field;

    vec2 ep = vec2(0.05,0.);
    vec2 rz= vec2(0);
    //# centered grid sampling
    for( int i=0; i<iterationTime1; i++ )
    {
        float t0 = f(p);
        float t1 = f(p + ep.xy);
        float t2 = f(p + ep.yx);
        vec2 g = vec2((t1-t0), (t2-t0))/ep.xx;
        vec2 t = vec2(-g.y,g.x);

        //# need update 'p' for next iteration,but give it some change.
        p += (mode_1_twist*0.01)*t + g*(1./mode_1_detail);
        p.x = p.x + sin( uTime*mode_2_speed/10.)/10.;
        p.y = p.y + cos(uTime*mode_2_speed/10.)/10.;
        rz= g;
    }
    field.vel = rz;
    return field;

    return field;
}
//---------------------------------------------------------------

float segm(in vec2 p, in vec2 a, in vec2 b) //from iq
{
	vec2 pa = p - a;
	vec2 ba = b - a;
	float h = clamp(dot(pa,ba)/dot(ba,ba), 0., 1.);
	return length(pa - ba*h)*20.*arrow_density;
}

float fieldviz(in vec2 p)
{
    vec2 ip = floor(p*arrow_density)/arrow_density + .5/arrow_density;
    vec2 t = field(ip).vel;
    float m = min(0.1,pow(length(t),0.5)*(arrow_length/arrow_density));
    vec2 b = normalize(t)*m;
    float rz = segm(p, ip, ip+b);
    vec2 prp = (vec2(-b.y,b.x));
    rz = min(rz,segm(p, ip+b, ip+b*0.65+prp*0.3));
    return clamp(min(rz,segm(p, ip+b, ip+b*0.65-prp*0.3)),0.,1.);
}


vec3 getRGB(in Field fld){
    vec2 p = fld.vel;
    float t = clamp(length(p), 0.0, 1.0);

    vec3 colorA = uColorA;
    vec3 colorB = uColorB;
    return mix(colorA, colorB, t);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 p = fragCoord.xy / uResolution.xy-0.5 ;
	p.x *= uResolution.x/uResolution.y;
    p *= scale;

    vec2 uv = fragCoord.xy / uResolution.xy;
    vec3 col;
    float fviz;

    Field fld = field(p);
    col = getRGB(fld) * 0.85;
	fragColor = vec4(col,1.0);
}

void main() {
  vec4 color;
  vec2 fragCoord = gl_FragCoord.xy;
  mainImage(color, fragCoord);
  gl_FragColor = color;
}