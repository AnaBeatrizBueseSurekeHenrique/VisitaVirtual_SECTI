extends Button
class_name  Botao
func mudar_texto(texto: String):
	self.text = texto

func mudar_pressed(funcao: Callable):
	self.pressed.connect(funcao)
