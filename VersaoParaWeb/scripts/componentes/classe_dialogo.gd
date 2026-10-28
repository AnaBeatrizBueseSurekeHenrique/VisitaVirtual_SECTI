extends Node
class_name ClasseDialogo

const BOTAO: PackedScene = preload("res://cenas/ui/botoes/botao.tscn")
const LINK_BUTTON: PackedScene = preload("res://cenas/ui/botoes/botao_link/link_button.tscn")

## Valor em que o dialogo se inicia
@export var _dialog_min : int
## Valor em que o dialogo atual termina
@export var _dialog_max : int
## Classe responsável por exibir o texto.
@export var _exibir_texto: ExibirTexto
## Local onde botões e links são armazenados no dialogo
@export var panel_botoes : GridContainer
## Armazena o NPC responsável pelo inicio do dialogo.
var npc : NPC
##Velocidade padrão em que a mensagem será exibida
var step = 0.05
##Id do texto atual, inicialmente, é igual a zero.
var _id :int
## Armazena se o dialogo fará com que o jogador mude de cena.
var mudaCena = false
## Armazena se o texto irá retornar a um texto anterior, ao invés prosseguir para o próximo texto na sequência.
var volta : bool = false
## Armazena o id de qual texto será retornado, caso a expressão volta seja verdadeira. 
var volta_id = 0
var texto_val
func _ready() -> void:
	_id = _dialog_min
	_inicializa_dialogo()

## Responsável por inicializar o dialogo, analisando que tipo de texto foi recebido.
func _inicializa_dialogo() -> void:
	var texto = DialogoCarregar.dialogo["falas"][_id] 
	match texto["dialogo"]:
		# Ou seja, caso o texto recebido for um link, adiciona um link na caixa de dialogo.
		"LINK":
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			panel_botoes.visible = true
			_exibir_texto._texto.visible = false
			adiciona_link_button()
			texto_val = texto["texto"]
			_exibir_texto.adicionar_link(texto["texto"], texto["link"])
		# Ou seja, caso o texto recebido for uma pergunta, adiciona botões com as opções de escolha disponíveis na caixa de dialogo.
		"PERGUNTA":
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			panel_botoes.visible = true
			texto_val = texto["texto"]
			_exibir_texto.adiciona_texto((texto["texto"]), 0.01)
			_exibir_texto.botao = true
			_adicionar_botoes(texto)
		# Ou seja, caso o texto deva retornar a um texto passado, ao invés de prosseguir para o próximo, após o término de sua exibição.
		"VOLTA":
			texto_val = texto["texto"]
			_exibir_texto.adiciona_texto(texto['texto'], step)
			volta = true
			volta_id = texto['volta']
		# Ou seja, caso deva ocorrer uma transição entre cenas após o fim do texto.
		"MUDA_CENA":
			texto_val = texto["texto"]
			_exibir_texto.adiciona_texto(texto['texto'], step)
			mudaCena = true
			ChangeScene.scene_name = texto["cena"]
			ChangeScene.number_jogador = texto["jogador_pos"]
		_:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			texto_val = texto["dialogo"]
			_exibir_texto.adiciona_texto(texto["dialogo"], step)
			
## Responsável por adicionar botões à caixa de dialogo, analisar o tipo de botão recebido e qual ação deve ocorrer ao ser clicado.

func _adicionar_botoes(texto: Dictionary):
	_exibir_texto.botao = true
	for opcao in texto["opcoes"]:
		var botao : Botao = BOTAO.instantiate()
		botao.mudar_texto(opcao['texto'])
		match opcao["acao"]:
			# Ou seja, ao clicar o botão, o dialogo apenas prossiguirá para o próxima frase.
			"avancar":
				botao.mudar_pressed(avancar_botao)
			# Ou seja, ao clicar o botão, o dialogo chegará a seu fim.
			"pular_fim":
				botao.mudar_pressed(
					func():
						get_tree().paused = false
						queue_free()
				)
			# Ou seja, ao clicar o botão, o dialogo avançará para uma frase a sua frente, cujo id é igual a *opção["id"]*
			"pula":
				botao.mudar_pressed(func():
					pula_dialogo(opcao["id"]))
			# Ou seja, ao clicar o botão, quando ocorrer o término da fala, o npc atual se tornará invisivel, e o npc de número opção["id"] se tornará visivel.
			"muda_falante":
				botao.mudar_pressed(func():
					npc._muda_falante(opcao["id"])
					_id = _dialog_max-1
					avanca_texto()
				)
			# Ou seja, ao clicar o botão, causa o término da visita, avançando a tela de créditos.
			"trigger_fim":
				botao.mudar_pressed(func():
					npc.fim = true
					_id = _dialog_max-1
					avanca_texto()
					)
			_:
				pass
		panel_botoes.add_child(botao)

## Responsável por adicionar um link no texto.
func adiciona_link_button():
	var link_botao = LINK_BUTTON.instantiate()
	panel_botoes.add_child(link_botao)
	_exibir_texto.link_button = link_botao
	
	link_botao.get_child(0).pressed.connect(_exibir_texto._on_link_button_pressed)
	link_botao.get_child(2).pressed.connect(_exibir_texto._on_link_button_pressed)

## Responsável por pular para cujo id é igual é id.
func pula_dialogo(id: int):
	_id = id-1
	avancar_botao()
## Ao botão ser clicado, todos os botões da caixa de dialogo são removidos, e  o texto volta a ser visivel.
func avancar_botao():
	_exibir_texto.botao = false
	for n in panel_botoes.get_children():
		panel_botoes.remove_child(n)
		n.queue_free() 	
	_exibir_texto._texto.visible = true
	avanca_texto()
	
func _process(_delta: float) -> void:
	#Proporção de texto visivel.
	var ui_ratio = _exibir_texto._texto.visible_ratio
	# Caso um botão, ou link. não estiver em tela, o usuário poderá pressionar a tecla de interagir para avançar e acelerar o texto
	# Caso contrário, será aguardado até o usuário pressionar um botão.
	if(!_exibir_texto.botao):

		#Caso todo o texto esteja visivel
		if Input.is_action_just_pressed("interagir") and ui_ratio >= 1:
			avanca_texto()
		#Faz com que letras apareçam mais rápido caso o jogador pressione o botão de interagir.
		elif Input.is_action_pressed("interagir"):
			_exibir_texto.step = 0.01
		else:
			_exibir_texto.step = 0.05
	else:
		# Se algum botão visivel for pressionado, todos os botões serão removidos da caixa de dialogo, e será prosseguido de acordo com a ação do botão.
		if(_exibir_texto.botao_pressionado):
			_exibir_texto.botao_pressionado = false
			_exibir_texto.botao = false
			_exibir_texto.step = 0.05
			_exibir_texto._texto.visible = true
			for n in panel_botoes.get_children():
				panel_botoes.remove_child(n)
				n.queue_free() 	
			avanca_texto()

func avanca_texto():
	if(! volta):
		_id += 1	
	else:
		_id = volta_id
		volta = false
		volta_id = 0
	#Caso a última mensagem tenha sido lida, apaga a caixa de dialogo.
	if(_id >= _dialog_max):
		get_tree().paused = false
		queue_free()	
		if(mudaCena == true):
			ChangeScene.change_scene()
	else:
		_inicializa_dialogo()
