extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if get_tree().paused:
		get_tree().paused = false
