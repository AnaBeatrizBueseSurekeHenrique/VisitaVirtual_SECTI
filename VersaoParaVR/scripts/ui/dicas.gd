extends Sprite3D

@onready var text_label :RichTextLabel = $SubViewportContainer/SubViewport/PanelContainer/MarginContainer/TextEdit


func _mudar_texto(texto_novo : String):
	self.visible = true
	text_label.text = texto_novo
