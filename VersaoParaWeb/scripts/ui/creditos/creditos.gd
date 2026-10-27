extends Control

@onready var scroll : ScrollContainer = $PanelContainer2/VBoxContainer/CenterContainer/MarginContainer/VBoxContainer/Scroll
var botao_pressionado = false
@onready var quicksand : ScrollContainer = $PanelContainer2/Licencas/QuickSand
@onready var painelPrincipal : VBoxContainer = $PanelContainer2/VBoxContainer
@onready var licencas : VBoxContainer = $PanelContainer2/Licencas
@onready var geistpixel : ScrollContainer = $PanelContainer2/Licencas/Geistpixel
@onready var passero : ScrollContainer = $PanelContainer2/Licencas/Passero
@onready var vt : ScrollContainer = $PanelContainer2/Licencas/Vt323
func _ready() -> void:
	painelPrincipal.visible = true
	quicksand.visible = false
	licencas.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	_loop_botao()

func _loop_botao():
	var tempo_scroll = 20
	while(not botao_pressionado):
		await scroll_para_baixo(tempo_scroll)
		await scroll_para_cima(tempo_scroll)
	
func _on_button_button_up() -> void:
	botao_pressionado = true
	ChangeScene.scene_name = "res://cenas/tela_inicial/tela_inicial.tscn"
	ChangeScene.change_scene()
	

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

func _ligar_licenca(val: bool) -> void:
	painelPrincipal.visible = (not val)
	botao_pressionado = (val)
	licencas.visible = (val)

func _on_quicksand_button_up() -> void:
	quicksand.visible = true
	_ligar_licenca(true)

func _on_geist_pixel_button_up() -> void:
	_ligar_licenca(true)
	geistpixel.visible = true

func _on_passero_button_up() -> void:
	passero.visible = true
	_ligar_licenca(true)

func _on_vt_323_button_up() -> void:
	vt.visible = true
	_ligar_licenca(true)


func _on_button_voltar_button_up() -> void:
	_ligar_licenca(false)
	vt.visible = false
	passero.visible = false
	geistpixel.visible = false
	quicksand.visible = false
