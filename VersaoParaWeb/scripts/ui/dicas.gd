extends Area3D
const DIALOGUE_BOX: PackedScene = preload("res://cenas/ui/dialogo_ui/dicas_ui.tscn")

@onready var _hud : CanvasLayer
var _new_dialog : Classe_Dicas


func _ready() -> void:
	_hud = get_tree().current_scene.get_node('hud')

func _on_area_entered(area: Area3D) -> void:
	if(area.get_parent().name == "Componente_Interacao"):
		if(!_hud.has_node('Dicas_ui') and GameState.get_game_state() != 4):
			_new_dialog = DIALOGUE_BOX.instantiate()
			_new_dialog.dialogo = 'Aperte A, W, S, D para se movimentar! Use M para pausar o jogo!'
			_hud.add_child(_new_dialog)

#
func _on_area_exited(area: Area3D) -> void:
	if(area.get_parent().name == "Componente_Interacao"):
		
		if(_hud.has_node('Dicas_ui') and _new_dialog != null):
			_hud.remove_child(_new_dialog)
			_new_dialog.queue_free()
			queue_free()
