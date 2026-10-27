extends StaticBody3D
@onready var interacao: Area3D = $Interacoes
const DIALOGUE_BOX: PackedScene = preload("res://cenas/ui/dialogo_ui/dicas_ui.tscn")

##Armazena a posição onde o jogador será transportado após sentar.
@onready var _marker : Marker3D = $Marker3D
@onready var jogador : Jogador
@onready var _hud : CanvasLayer
var _new_dialog : Classe_Dicas

func _ready() -> void:
	jogador = get_tree().current_scene.get_node('Jogador')
	_hud = get_tree().current_scene.get_node('hud')
	interacao.interagir = sentar


func sentar():
	
	if(_hud.has_node('Dicas_ui') and _new_dialog != null):
		_hud.remove_child(_new_dialog)
		_new_dialog.queue_free()
	# Ou seja, caso o estado atual do jogador for diferente de SENTADO, irá o teletransportar
	# Para o marcador.
	if(GameState.get_game_state() != 3):
		jogador.position = _marker.global_position
	GameState.mudar_sitting()


func _on_interacoes_area_entered(area: Area3D) -> void:
	if(area.get_parent().name == "Componente_Interacao"):
		
		if(!_hud.has_node('Dicas_ui') and (GameState.get_game_state() != 3 and GameState.get_game_state() != 4)):
			_new_dialog = DIALOGUE_BOX.instantiate()
			_new_dialog.dialogo = 'Aperte z para se sentar!'
			_hud.add_child(_new_dialog)


func _on_interacoes_area_exited(area: Area3D) -> void:
	if(area.get_parent().name == "Componente_Interacao"):
		
		if(_hud.has_node('Dicas_ui') and _new_dialog != null):
			_hud.remove_child(_new_dialog)
			_new_dialog.queue_free()
