extends Camera3D

var pausa : Pause
var jogador : Jogador

func _process(_delta: float) -> void:
	if(pausa):
		if(self.fov != pausa.fov_slider.value):
			self.fov = pausa.fov_slider.value
			
