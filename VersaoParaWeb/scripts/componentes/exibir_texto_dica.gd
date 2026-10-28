extends Control
class_name ExibirDicas

@export_category('Objetos')
##Local onde será exibida o texto do dialogo
@export var _texto: RichTextLabel
##Velocidade em que as letras do texto serão adicionadas.
@export var step: float

##Adiciona texto, de forma visual ao jogador.
func adiciona_texto(texto: String, _step: float)-> void:
	_texto.text = tr(texto)
	_texto.visible_characters = 0
	step = _step
	# Ou seja, enquanto todo o texto não tiver sido exibido.
	while(_texto.visible_ratio < 1):
		if not is_inside_tree():
			return
		# Cria um timer, para que os caracteres apareçam lentamente.
		await get_tree().create_timer(step).timeout
		_texto.visible_characters +=1
