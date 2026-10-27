extends Area3D
# Script responsável por realizar a transição entre cenas
@export var caminho_cena : String
@export var numero_jogador = 0
## Ao usuário entrar em uma área que possui esse componente, realiza a transição para a cena de nome caminho_cena.
func _on_area_entered(_area: Area3D) -> void:
	ChangeScene.scene_name = caminho_cena
	ChangeScene.number_jogador = numero_jogador
	ChangeScene.change_scene()
