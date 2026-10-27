extends Control

@onready var audio : AudioStreamPlayer = $AudioStreamPlayer
##Garante que o jogador possa ver seu moue ao acessar essa tela.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

##Ao pressionar o botão de iniciar, muda a cena para a cena que contém a parte externa do prédio
## Ou seja, a cena inicial.
func _on_button_pressed() -> void:	
	audio.play()
	#await audio.finished
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	ChangeScene.scene_name = "res://cenas/salas/externo.tscn"
	ChangeScene.number_jogador = 0
	ChangeScene.change_scene()
