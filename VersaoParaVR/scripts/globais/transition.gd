extends Node3D
##Script responsável por fazer transições de fade_in e fade_out para as cenas.

@onready var rect_out = $SubViewportContainer/SubViewport/CanvasLayer/RectOut
@onready var animation_player = $SubViewportContainer/SubViewport/CanvasLayer/RectOut/AnimationPlayer
func _sair_cena():
	animation_player.play("SairCena")
	
	await  animation_player.animation_finished
	
func _entrar_cena():
	
	animation_player.play("EntrarCena")
	await  animation_player.animation_finished

func _on_ready() -> void:
	
	##Ao iniciar, deixa a opacidade, o canal alfa, do quadrado preto, como 0, deixando o transparente e não visivel.
	rect_out.color.a = 0
	#self.visible = false
