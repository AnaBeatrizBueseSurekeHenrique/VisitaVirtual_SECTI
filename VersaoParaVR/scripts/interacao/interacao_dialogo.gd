extends StaticBody3D
##Classe responsável por lidar com interações de dialogos dos NPCs
class_name  NPC
enum State { ## Armazena o estado atual do npc, controlando suas animações
	IDLE, ## Quando o npc está em estado de repouso,
	SITTING, ## Quando o npc está sentado,
	WALK ## Quando o npc está caminhando.
}
## Tocador de animações, possui armazenado as animações criadas em Blender do personagem.
@onready var lobo_anim : AnimationPlayer = $lobo/AnimationPlayer
## Área de interações do npc, responsável por realizar as interações de dialogo.
@onready var interacao: Area3D = $Interacoes
## Colisão da área de interação, responsável por controlar se a interação está ativa ou inativa.
@onready var colisao : CollisionShape3D = $Interacoes/CollisionShape3D
##Indica se o dialogo acarretará em uma troca de cena. Por padrão, é falso.
@export var _muda_cena: bool = false
##Caso este diálogo case uma troca de cena, esta variável armazena o caminho absoluto desta cena. Por padrão, é vázio.
@export var _cena_nome : String = " "
##Nome de em qual arquivo .json está armazenado o dialogo utilizado.
@export var _dialogo_arq: String = "res://dialogos/dialogo_inicio.json"
##Armazena se esse dialogo causará o fim do jogo, por padrão, é falso.
var fim = false
## Armazena a caixa de dialogo da cena
@export var hud : ClasseDialogo
## Armazena se o dialogo, após o fim de sua exibição, causará o npc se movimentar.
var mudar_posicao_agora
## Armazena a caixa de dicas da cena.
@export var dicas : Sprite3D
##Armazena quais linhas do .json serão utilizadas neste dialogo.
var DictionaryDialogue: Dictionary= {
	"_dialog_min" : 0,
	"_dialog_max" : 0	
}
## Array que armazena multiplos valores de fim e inicio, permitindo alterar frases faladas do npc após interações com o usuário.
@export var _array_dialogue: Array=[DictionaryDialogue]
##Armazena se o NPC se movimentará após o fim do dialogo.
@export var muda_pos : bool =false
## Armazena os locais para onde o NPC deverá se movimentar, caso muda_pos for true.
@export var markers : Array[Marker3D]
## Armazena o CharacterBody3D do NPC, caso se movimentar, permitindo sua movimentação.
@export var npc : CharacterBody3D

##Armazena se a interação causará uma mudança de NPC, ou seja, o NPC atual se tornar invisivel, e um novo se tornar visivel.
@export var muda_falante : bool = false
##Quais possíveis falantes, caso muda_falante for igual a  true.
@export var falantes : Array[NPC]
## Armazena se o dialogo atual foi iniciado
var dialogo_iniciado = false
## Armazena qual outro npc será interagivel após o fim deste dialogo.
var id_falante = 0
## Armazena o estado atual do npc.
@export var currentSate : State

func _ready() -> void:
	##Se o NPC for invisivel, sua colisão será desabilitada, impedindo de usuários interagirem com ele.
	if(visible):
		colisao.set_deferred("disabled", false)
	#Adiciona a interação.
	interacao.interagir = _mostrarHud
	# Faz com que a animação toque mesmo quando o jogo estiver pausado.
	lobo_anim.process_mode = Node.PROCESS_MODE_ALWAYS
	# Toca a animação correspondente do estado atual.
	match currentSate:
		State.IDLE:		
			lobo_anim.play("Idle")
		State.SITTING:
			lobo_anim.play("Sentar")
		
###Função responsável por mostrar o dialógo, iniciando uma nova caixa de dialogo, e preenchendo suas informações.
func _mostrarHud() -> void:	
		DialogoCarregar.carregarDialogo(_dialogo_arq)
		
		if(GameState.get_game_state() != 3):
			dicas.visible = false

			GameState.mudar_conversando()
			hud.visible = true
			hud._id = _array_dialogue[0]["_dialog_min"]
			hud.npc = self
			hud._dialog_max = _array_dialogue[0]["_dialog_max"]
			
			##Caso houver outras combinações de _dialog_min e dialog_max disponiveis, retira a frase atual da fila.
			if(_array_dialogue.size() > 1):
				_array_dialogue.pop_front()
			hud.mudaCena = _muda_cena
			hud.mudar_posicao = muda_pos
			ChangeScene.scene_name = _cena_nome
			hud._inicializa_dialogo()
			hud.process_mode = Node.PROCESS_MODE_ALWAYS
	
			dialogo_iniciado = true
			colisao.disabled = true
			interacao.haInteracao = false

func ligar_interact():
	colisao.set_deferred("disabled", false)
	interacao.haInteracao = true
			
func _process(_delta: float) -> void:
	if(dialogo_iniciado):
		if(mudar_posicao_agora):
			npc.markers = markers.duplicate()
			markers.clear()
			mudar_posicao_agora = false
			dialogo_iniciado = false
		
		if(!muda_pos):
			dialogo_iniciado = false

	if(fim):
		fim = false
		ChangeScene.scene_name = 'res://cenas/cenas_vr/cena_creditos.tscn'
		ChangeScene.change_scene() 
	if(muda_falante):
		visible = false
		muda_falante = false
		colisao.disabled = true
		
		falantes[id_falante].visible = true
		falantes[id_falante].colisao.disabled = false
func _on_interacoes_area_entered(_area: Area3D) -> void:
	dicas.visible = true
	dicas._mudar_texto("Aperte o trigger esquerdo para falar!")
	


func _on_interacoes_area_exited(_area: Area3D) -> void:
	dicas.visible = false
	
				
func _muda_falante(id : int) -> void:
	muda_falante = true
	id_falante = id
