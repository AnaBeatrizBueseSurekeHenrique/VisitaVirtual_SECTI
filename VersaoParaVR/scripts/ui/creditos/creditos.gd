extends Node

@onready var scroll : ScrollContainer = $SubViewportContainer/SubViewport/PanelContainer2/VBoxContainer/CenterContainer/MarginContainer/VBoxContainer/Scroll
var botao_pressionado = false
func _ready() -> void:

	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	_loop_botao()

func _loop_botao():
	var tempo_scroll = 20
	while(not botao_pressionado):
		await scroll_para_baixo(tempo_scroll)
		await scroll_para_cima(tempo_scroll)
	


func scroll_para_baixo(tempo_em_segundos: float):
	var tween = create_tween()
	
	var scroll_maximo = scroll.get_v_scroll_bar().max_value
	
	tween.tween_property(scroll, "scroll_vertical", scroll_maximo, tempo_em_segundos).set_trans(Tween.TRANS_LINEAR)
	await tween.finished

func scroll_para_cima(tempo_em_segundos: float):
	var tween = create_tween()
	
	var scroll_min = scroll.get_v_scroll_bar().min_value
	
	tween.tween_property(scroll, "scroll_vertical", scroll_min, tempo_em_segundos).set_trans(Tween.TRANS_LINEAR)
	await  tween.finished
