extends Camera3D
# Script responsável por permitir a alteração de fov na camera 
# Enquanto o jogador está no menu de pausa.

var pausa : Pause
var jogador : Jogador

func _process(_delta: float) -> void:
	if(pausa):
		if(self.fov != pausa.fov_slider.value):
			self.fov = pausa.fov_slider.value
			
