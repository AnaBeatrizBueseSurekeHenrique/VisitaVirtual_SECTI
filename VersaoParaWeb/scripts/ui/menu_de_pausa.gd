extends Control

class_name Pause
@onready var ConfigPanel : PanelContainer = $Configs
@onready var Pausa : PanelContainer = $Pausa
@onready var Controles : PanelContainer = $Controles

@onready var fov_number : LineEdit = $"Configs/MarginContainer/Configuracoes/HBoxContainer/HBoxContainer/FOV_number"
@onready var fov_slider: HSlider = $"Configs/MarginContainer/Configuracoes/HBoxContainer/HBoxContainer/FOV_Slider"
@onready var mouse_number : LineEdit = $Configs/MarginContainer/Configuracoes/Mouse/Mouse_number
@onready var mouse_slider : HSlider = $Configs/MarginContainer/Configuracoes/Mouse/Mouse_Slider


func _despausar():
	get_tree().paused = false
	self.visible = false



func _on_retornar_button_up() -> void:
	_despausar()


func _on_fov_slider_value_changed(value: float) -> void:
	fov_number.text = str(fov_slider.value)



func _on_fov_number_text_submitted(new_text: String) -> void:
	fov_slider.value = new_text.to_float()
	fov_number.text = str(fov_slider.value)


func _on_configuracoes_button_up() -> void:
	ConfigPanel.visible = true
	Pausa.visible = false


func _on_retornar_config_button_up() -> void:
	ConfigPanel.visible = false
	Pausa.visible = true


func _on_mouse_slider_value_changed(value: float) -> void:
	mouse_number.text = str(mouse_slider.value)


func _on_mouse_number_text_submitted(new_text: String) -> void:
	mouse_slider.value = new_text.to_float()
	mouse_number.text = str(mouse_slider.value)



func _on_controles_button_up() -> void:
	Controles.visible = true
	ConfigPanel.visible = false


func _on_retornar_controles_button_up() -> void:
	Controles.visible = false
	ConfigPanel.visible = true
