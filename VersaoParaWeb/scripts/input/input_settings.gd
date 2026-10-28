extends MarginContainer

@onready var input_button = preload("res://cenas/ui/pausa/input_button.tscn")
@onready var lista_acoes = $VBoxContainer/ScrollContainer/ListaAcoes 

var is_remapping = false
var action_to_remap = null
var remapping_button = null
var lista_keys : Array[String]
var old_text

func _ready():
	_criar_acoes()

## Dicionario de nomes das ações, segundo o input map do projeto
## E o nome que será exibido ao jogador.
var acoes = {
	"cima" : "Frente",
	"esquerda": "Esquerda",
	"direita": "Direita",
	"baixo": "Trás",
	"pulo": "Pular",
	"interagir": "Interações",
	"correr": "Correr",
	"agachar": "Andar Devagar",
	"esc": "Menu"
}
func _criar_acoes() -> void:
	for item in lista_acoes.get_children():
		item.queue_free()
		
	for action in acoes:
		var button = input_button.instantiate()
		var action_label = button.find_child("LabelAction")
		var input_label = button.find_child("InputAction")
		action_label.text = acoes[action]
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			# Por padrão, ao Godot receber um input por teclado, o nome final é "Tecla - Pshysical"
			# Portanto, para dar nome as ações, retiro "Pshysical" da string
			input_label.text = events[0].as_text().trim_suffix(" - Physical")
			lista_keys.append(input_label.text)
			match input_label.text:
				"Escape":
					input_label.text = "Esc"
				"Space":
					input_label.text = "Espaço"
				"Left":
					input_label.text = "←"
				"Right":
					input_label.text = "→"
				"Up":
					input_label.text = "↑"
				"Down":
					input_label.text = "↓"
				_:
					pass
		else:
			input_label.text = ""
		lista_acoes.add_child(button)
		button.pressed.connect(on_input_button_pressed.bind(button, action))

func on_input_button_pressed(button, action) -> void:
	if not is_remapping:
		is_remapping = true
		action_to_remap = action
		remapping_button = button
		old_text = 	button.find_child("InputAction").text
		button.find_child("InputAction").text = "Aperte a tecla desejada...."

func _input(event):
	if is_remapping:
		if(event is InputEventKey) or (event is InputEventMouseButton and event.pressed):
			if( event is InputEventMouseButton and event.double_click):
				event.double_click = false
			if(event.as_text().trim_suffix(" - Physical") in lista_keys and lista_keys[remapping_button.get_index()] != event.as_text()):
				var input_label = remapping_button.find_child("InputAction")
				input_label.text = "Outra ação já utiliza essa tecla!!"
				await get_tree().create_timer(5).timeout
				if(input_label):
					if(input_label is Label):
						input_label.text = old_text
				is_remapping = false
				action_to_remap = null
				remapping_button = null
				return
			InputMap.action_erase_events(action_to_remap)
			InputMap.action_add_event(action_to_remap, event)
			_update_action_list(remapping_button, event)
			is_remapping = false
			action_to_remap = null
			remapping_button = null
			accept_event()
func _update_action_list(button, event) -> void:
	var input_label = button.find_child("InputAction")
	input_label.text = event.as_text().trim_suffix(" - Physical")
	
	lista_keys[button.get_index()] = event.as_text()
	match input_label.text:
				"Escape":
					input_label.text = "Esc"
				"Space":
					input_label.text = "Espaço"
				"Left":
					input_label.text = "←"
				"Right":
					input_label.text = "→"
				"Up":
					input_label.text = "↑"
				"Down":
					input_label.text = "↓"
				_:
					pass


func _on_reset_button_button_up() -> void:
	InputMap.load_from_project_settings()
	_criar_acoes()
