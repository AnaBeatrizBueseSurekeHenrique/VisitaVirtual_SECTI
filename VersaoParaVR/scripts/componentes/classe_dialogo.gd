extends Node3D
class_name ClasseDialogo
## Local que contém os 3 botões para o usuário.
const BOTAO: PackedScene = preload("res://cenas/ui/dialogo_ui/contain_options.tscn")
## Utilizado para testes, verifica se o botão trigger foi pressionado.
var pressionado_trigger = false
## Utilizados para verificar se, atualmente, possui botões no dialogo, usados para evitar que
## o usuário pule frases, ou aperte botões antes de poder ler as opções.
var possui_botoes_atual = false
## Utilizados para verificar se, atualmente, possui botões no dialogo, usados para evitar que
## o usuário pule frases, ou aperte botões antes de poder ler as opções.
var contem_botao : bool = false
## Utilizados para verificar se, atualmente, possui botões no dialogo, usados para evitar que
## o usuário pule frases, ou aperte botões antes de poder ler as opções.
var pode_mudar_opcao : bool = true
## Valor em que o dialogo atual termina
@export var _dialog_max : int
## Classe responsável por exibir o texto.
@export var _exibir_texto: ExibirTexto
## Local onde botões e links são armazenados no dialogo
@onready var panel_botoes :PanelContainer = $SubViewportContainer/SubViewport/Control/MarginContainer2/PanelContainer/MarginContainer/MarginContainer/VBoxContainer/ContemBotoes
## Armazena o NPC responsável pelo inicio do dialogo.
var npc : NPC
##Velocidade padrão em que a mensagem será exibida
var step = 0.01
##Id do texto atual, inicialmente, é igual a zero.
var _id :int
## Porcentagem de texto exibido, é calculado por 
## Caracteres do texto total - Caracteres do texto exibido
var ui_ratio = 100
## Armazena se o dialogo fará com que o jogador mude de cena.
var mudaCena = false
## Armazena se o texto irá retornar a um texto anterior, ao invés prosseguir para o próximo texto na sequência.
var volta : bool = false
## Armazena o id de qual texto será retornado, caso a expressão volta seja verdadeira. 
var volta_id = 0
## Armazena o texto armazenado no Json.
var texto_val
## Armazena se, ao terminar o dialogo, o npc se movimentará.
var mudar_posicao = false
## Armazena o id do botã atualmente exibido na tela.
var botao_atual = 0
## Armazena se o usuário pode avançar para o próximo dialogo.
var pode_passar = true
## Armazena se o dialogo atual alterou qual npc poderá ser interagido.
var mudou_falante = false

func _ready() -> void:
	# Desliga seu processamento, e se torna invisivel, evitando erros de código.
	self.process_mode = Node.PROCESS_MODE_DISABLED
	self.visible = false
## Responsável por inicializar o dialogo, analisando que tipo de texto foi recebido.
func _inicializa_dialogo() -> void:
	pode_passar = true
	var texto = DialogoCarregar.dialogo["falas"][_id]
	match texto["dialogo"]:
	
		# Ou seja, caso o texto recebido for uma pergunta, adiciona botões com as opções de escolha disponíveis na caixa de dialogo.
		"PERGUNTA":
			contem_botao = true
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			panel_botoes.visible = true
			texto_val = texto["texto"]
			_exibir_texto.adiciona_texto((texto["texto"]), 0.01)
			_exibir_texto.botao = true
			_adicionar_botoes(texto)
		# Ou seja, caso o texto deva retornar a um texto passado, ao invés de prosseguir para o próximo, após o término de sua exibição.
		"VOLTA":
			contem_botao = false
			texto_val = texto["texto"]
			_exibir_texto.adiciona_texto(texto['texto'], step)
			volta = true
			volta_id = texto['volta']
		# Ou seja, caso deva ocorrer uma transição entre cenas após o fim do texto.
		"MUDA_CENA":
			contem_botao = false
			texto_val = texto["texto"]
			_exibir_texto.adiciona_texto(texto['texto'], step)
			mudaCena = true
			ChangeScene.scene_name = texto["cena"]
		# Casos gerais, evitando erros.
		_:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			texto_val = texto["dialogo"]
			_exibir_texto.adiciona_texto(texto["dialogo"], step)
			
## Responsável por adicionar botões à caixa de dialogo, analisar o tipo de botão recebido e qual ação deve ocorrer ao ser clicado.
func _adicionar_botoes(texto: Dictionary):
	pode_passar = false
	_exibir_texto.botao = true
	possui_botoes_atual = false
	await get_tree().create_timer(0.5).timeout
	for opcao in texto["opcoes"]:
		var opcaoAtual = BOTAO.instantiate()
		var local_botao : Button = opcaoAtual.get_child(-2) 
		local_botao.text = opcao['texto']
		match opcao["acao"]:
			# Ou seja, ao clicar o botão, o dialogo apenas prossiguirá para o próxima frase.
			"avancar":
				local_botao.connect("pressed", avanca_texto)
			# Ou seja, ao clicar o botão, o dialogo chegará a seu fim.
			"pular_fim":
				local_botao.connect("pressed", (
					func():
						get_tree().paused = false
						queue_free()
				))
			# Ou seja, ao clicar o botão, o dialogo avançará para uma frase a sua frente, cujo id é igual a *opção["id"]*
			"pula":
				local_botao.connect("pressed",(func():
					pula_dialogo(opcao["id"])))
			# Ou seja, ao clicar o botão, quando ocorrer o término da fala, o npc atual se tornará invisivel, e o npc de número opção["id"] se tornará visivel.
			"muda_falante":
				local_botao.connect("pressed",(func():
					npc._muda_falante(opcao["id"])
					npc.muda_falante = true
					_id = _dialog_max-1
					mudou_falante = true
					avanca_texto()
					
				))
			# Ou seja, ao clicar o botão, causa o término da visita, avançando a tela de créditos.
			"trigger_fim":
				local_botao.connect("pressed",(func():
					npc.fim = true
					_id = _dialog_max-1
					avanca_texto()
					))
			_:
				pass
		panel_botoes.add_child(opcaoAtual)
	# Deixa visivel a primeira opção.
	panel_botoes.get_child(0).visible = true
	possui_botoes_atual = true
	botao_atual = 0
## Ao usuário pressionar uma tecla que permita avanço de botões, essa função é chamada
func _avancar_botoes():
	if(pode_mudar_opcao):
		pode_mudar_opcao = false
		panel_botoes.get_child(botao_atual).visible = false
		if(botao_atual + 1 > panel_botoes.get_child_count() -1):
			botao_atual = 0
		else:
			botao_atual += 1
		panel_botoes.get_child(botao_atual).visible = true
		# Utilizado para evitar que o usuário pressione multiplas vezes o botão de avançar
		# Pulando multiplos botões de uma vez, essa pausa permite que apenas um botão seja avançado por vez.
		await get_tree().create_timer(0.5).timeout
		pode_mudar_opcao = true
## Ao usuário pressionar uma tecla que permita o retorno de botões, essa função é chamada.

func _voltar_botoes():
	if(pode_mudar_opcao):
		pode_mudar_opcao = false
		panel_botoes.get_child(botao_atual).visible = false
		if(botao_atual -1 < 0):
			botao_atual = panel_botoes.get_child_count()-1
		else:
			botao_atual -= 1
		panel_botoes.get_child(botao_atual).visible = true
		# Utilizado para evitar que o usuário pressione multiplas vezes o botão de avançar
		# Pulando multiplos botões de uma vez, essa pausa permite que apenas um botão seja avançado por vez.
		await get_tree().create_timer(0.5).timeout
		pode_mudar_opcao = true
	
## Ao usuário pressionar o botão visivel, realiza a função do respectivo botão, e retira todos os botões da cena.
func _aperta_botao():
	if(possui_botoes_atual and contem_botao):
		possui_botoes_atual = false
		var local_botao : Button = panel_botoes.get_child(botao_atual).get_child(-2) 
		local_botao.pressed.emit()
		
		for n in panel_botoes.get_children():
			panel_botoes.remove_child(n)
			n.queue_free() 
		contem_botao = false

func pula_dialogo(id: int):
	_id = id-1
	avanca_texto()
	await get_tree().create_timer(1).timeout
	pode_passar = true
## Ao botão ser clicado, todos os botões da caixa de dialogo são removidos, e  o texto volta a ser visivel.
func avancar_botao():
	
	_exibir_texto._texto.visible = true
	
	avanca_texto()
	
func _process(_delta: float) -> void:

	ui_ratio = (len(_exibir_texto.texto_og)-len(_exibir_texto._texto.text))
	# Funções utilizadas para testes em desktop.
	if Input.is_action_pressed("Interagir") and ui_ratio < 1:
		
			if(not contem_botao):
				avanca_texto()
			else:
				_aperta_botao()
	if(Input.is_action_pressed("avancar") and ui_ratio < 1):
		_avancar_botoes()
	if(Input.is_action_just_pressed("voltar") and ui_ratio < 1):
		_voltar_botoes()
		##Faz com que letras apareçam mais rápido caso o jogador pressione o botão de interagir.
		#elif pressionado_trigger:
			#_exibir_texto.step = 0.01
		#else:
			#_exibir_texto.step = 0.05
	#else:
		## Se algum botão visivel for pressionado, todos os botões serão removidos da caixa de dialogo, e será prosseguido de acordo com a ação do botão.
		#if(_exibir_texto.botao_pressionado):
			#_exibir_texto.botao_pressionado = false
			#_exibir_texto.botao = false
			#_exibir_texto.step = 0.05
			#_exibir_texto._texto.visible = true
			#for n in panel_botoes.get_children():
				#panel_botoes.remove_child(n)
				#n.queue_free() 	
			#avanca_texto()


func avanca_texto():
	if(! volta):
		_id += 1	
	else:
		_id = volta_id
		volta = false
		volta_id = 0
	#Caso a última mensagem tenha sido lida, apaga a caixa de dialogo.
	if(_id >= _dialog_max):
		self.visible = false
		self.process_mode = Node.PROCESS_MODE_DISABLED
		npc.mudar_posicao_agora = mudar_posicao
		npc.colisao.disabled = true
		if(mudaCena == true):
			ChangeScene.change_scene()
		await get_tree().create_timer(0.5).timeout
		if(is_instance_valid(npc)):
			if(not mudou_falante and not npc.fim):
				
				npc.interacao.haInteracao = true
				npc.colisao.disabled = false
			else:
				mudou_falante = false	
		GameState.mudar_idle()
		
	else:
		_inicializa_dialogo()
