extends Node
class_name ExibirTexto

@export_category('Objetos')
##Local onde será exibida o texto do dialogo
@export var _texto: RichTextLabel
##Velocidade em que as letras do texto serão adicionadas.
@export var step: float

var texto_og : String
##Armazena se há botões na caixa de dialogo
var botao = false;
##Armazena se o botão na caixa de dialogo foi pressionado.
var botao_pressionado = false;
##Adiciona texto, de forma visual ao jogador.
func adiciona_texto(texto: String, _step: float)-> void:
	texto_og = texto
	_texto.text = ""
	step = _step
	while(len(texto)-(len(_texto.text)) > 0):
		await get_tree().create_timer(step).timeout
		_texto.text = texto.substr(0, (len(_texto.text))+1)
	
