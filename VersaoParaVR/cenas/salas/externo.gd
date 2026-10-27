extends Node3D

@export var text_mesh : MeshInstance3D
# Called when the node enters the scene tree for the first time.

#func _input(event: InputEvent) -> void:
	#if(event.as_text().split(" ")[0] == "Mouse" and event.as_text().split(" ")[1] == "motion"): 
		#return
	#text_mesh.text.text = event.as_text()
