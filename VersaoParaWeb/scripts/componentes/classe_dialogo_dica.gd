extends Node
##Classe responsável por exibir dicas ao usuário.
class_name Classe_Dicas

##Armazena o texto a ser exibido.
@export var dialogo : String
##Responsável por realizar a exibição da dica ao usuário.
@export var _exibir_texto: ExibirDicas

func _ready() -> void:
	_inicializa_dialogo()
func _inicializa_dialogo() -> void:
	_exibir_texto.adiciona_texto(dialogo, 0.01)
