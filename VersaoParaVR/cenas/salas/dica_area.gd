extends Area3D
@export var hud : Sprite3D

# Called when the node enters the scene tree for the first time.


func _on_area_entered(_area: Area3D) -> void:
	hud.visible = true
	hud._mudar_texto("Use o controle direito para se movimentar!")


func _on_area_exited(_area: Area3D) -> void:
	hud.visible = false
	self.queue_free()
