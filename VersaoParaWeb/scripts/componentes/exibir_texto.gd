extends Control
class_name ExibirTexto

@export_category('Objetos')
##Local onde será exibida o texto do dialogo
@export var _texto: RichTextLabel
##Velocidade em que as letras do texto serão adicionadas.
@export var step: float

var link_button: HBoxContainer

##Armazena se há botões na caixa de dialogo
var botao = false;
##Armazena se o botão na caixa de dialogo foi pressionado.
var botao_pressionado = false;
##Adiciona texto, de forma visual ao jogador.
func adiciona_texto(texto: String, _step: float)-> void:
	_texto.text = tr(texto)
	_texto.visible_characters = 0
	step = _step
	while(_texto.visible_ratio < 1):
		await get_tree().create_timer(step).timeout
		_texto.visible_characters +=1
	
##Responsável por adicionar um link a caixa de dialogo, com link_texto sendo o texto exibido ao jogador,
## e link_url sendo a url que o jogador será levado ao clicar no link.
func adicionar_link(link_texto: String, link_url: String):
	botao = true
	var link = link_button.get_child(0)
	link.text = link_texto
	link.uri = link_url	

##Ao pressionar o botão, marca o botão como pressionado, e disconecta essa função do botão.
func _on_link_button_pressed() -> void:
	botao_pressionado = true
	link_button.get_child(0).pressed.disconnect(_on_link_button_pressed)
	link_button.get_child(2).pressed.disconnect(_on_link_button_pressed)
