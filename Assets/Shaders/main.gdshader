shader_type canvas_item;

const float dim = 0.2;
const float glow = 0.000015;
uniform sampler2D screen_texture: hint_screen_texture, repeat_disable, filter_linear_mipmap;

void fragment() {
  COLOR.rgb = texture(screen_texture, UV).rgb;
  
  int near = 0;
  for (float i = -20.0; i <= 20.0; i+=2.0) {
    for (float j = -20.0; j <= 20.0; j+=2.0) {
      if (sqrt(pow(i, 2) + pow(j, 2)) > 18.38) {
        continue;
      }
      vec4 n = texture(screen_texture, UV + vec2(
          SCREEN_PIXEL_SIZE.x * j,
          SCREEN_PIXEL_SIZE.y * i          
        ));
      if (n.r > 0.7 && n.b < 0.3) {
        near+=int(20.0 - abs(j))+int(20.0 - abs(i));
        float b = glow * (((20.0 - abs(j))) + ((20.0 - abs(i))));
        COLOR.rgb += vec3(b, b, b);
      }
    }
  }

  float m = smoothstep(0.1, 0.7, distance(UV, vec2(0.5,0.5))) + dim;
  if (near < 1300) {
    COLOR.rgb = mix(COLOR.rgb, vec3(0,0,0), m);
  } else {
    COLOR.rgb = mix(COLOR.rgb, COLOR.rgb - vec3(0.3, 0.3, 0.3), m);
  }
}