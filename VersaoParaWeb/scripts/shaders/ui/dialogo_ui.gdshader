shader_type canvas_item;

uniform float blur_amount : hint_range(0.0, 5.0) = 2.5;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;


void fragment() {
    // Pega o que está atrás do ColorRect na tela, e aplica um filtro de borrão..
    COLOR = textureLod(SCREEN_TEXTURE, SCREEN_UV, blur_amount);
}