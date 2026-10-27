extends Node
##Variábel global resposável por alterar a cena atual.
var loading_screen : XRToolsStaging
var main : Node3D 

##Nome da cena para qual será mudada.
var scene_name: String

func _ready() -> void:
	main = get_tree().root.get_child(-1)
func change_scene():
	var cena = main.get_child(-1)
	# Remove a cena atual da cena principal
	main.call_deferred("remove_child", cena)
	var new_scene = load(scene_name).instantiate()
	# Adiciona a nova cena a cena principal.
	main.add_child(new_scene)
	
	await get_tree().process_frame
	cena.queue_free()
