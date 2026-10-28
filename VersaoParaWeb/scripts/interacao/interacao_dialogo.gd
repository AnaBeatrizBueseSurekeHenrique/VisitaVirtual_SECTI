extends StaticBody3D
##Classe responsável por lidar com interações de dialogos dos NPCs
class_name  NPC


enum State {
	IDLE,
	SITTING,
	WALK
}
@onready var interacao: Area3D = $Interacoes
@onready var colisao : CollisionShape3D = $Interacoes/CollisionShape3D
@export var _hud: CanvasLayer = null
##Indica se o dialogo acarretará em uma troca de cena. Por padrão, é falso.
@export var _muda_cena: bool = false
##Caso este diálogo case uma troca de cena, esta variável armazena o caminho absoluto desta cena. Por padrão, é vázio.
@export var _cena_nome : String = " "
##Nome de em qual arquivo .json está armazenado o dialogo utilizado.
@export var _dialogo_arq: String = "res://dialogos/dialogo_teste.json"
##Cena que armazena a caixa de dialogo.
const DIALOGUE_BOX: PackedScene = preload("res://cenas/ui/dialogo_ui/dialogo_ui.tscn")
##Cena que armazena a caixa de dicas.
const DICA: PackedScene = preload("res://cenas/ui/dialogo_ui/dicas_ui.tscn")
var _new_dica : Classe_Dicas
##Armazena se esse dialogo causará o fim do jogo, por padrão, é falso.
var fim = false


##Armazena quais linhas do .json serão utilizadas neste dialogo.
var DictionaryDialogue: Dictionary= {
	"_dialog_min" : 0,
	"_dialog_max" : 0	
}
@onready var lobo_anim : AnimationPlayer = $lobo/AnimationPlayer
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
var _new_dialog : ClasseDialogo
var dialogo_iniciado = false
var id_falante = 0
@export var currentSate : State
	
func _ready() -> void:
	##Se o NPC for invisivel, sua colisão será desabilitada, impedindo de usuários interagirem com ele.
	if(visible):
		colisao.disabled = false
	#Adiciona a interação.
	interacao.interagir = _mostrarHud
	lobo_anim.process_mode = Node.PROCESS_MODE_ALWAYS
	match currentSate:
		State.IDLE:		
			lobo_anim.play("Idle")
		State.SITTING:
			lobo_anim.play("Sentar")
	
		
##Função responsável por mostrar o dialógo, iniciando uma nova caixa de dialogo, e preenchendo suas informações.
func _mostrarHud() -> void:	
		DialogoCarregar.carregarDialogo(_dialogo_arq)
		#Se o estado de jogo atual não é SENTADO, adiciona dica.
		#Caso já houver uma dica existente, remove a dica e a troca pela nova.
		if(GameState.get_game_state() != 3):
			var dica = _hud.get_node_or_null("Dicas_ui")
			if dica:
				_hud.remove_child(dica)
				dica.queue_free()

				
			GameState.mudar_conversando()
			#Instância uma nova caixa de dialogo
			_new_dialog = DIALOGUE_BOX.instantiate()
			_new_dialog.npc = self
			_new_dialog._dialog_min = _array_dialogue[0]["_dialog_min"]
			_new_dialog._dialog_max = _array_dialogue[0]["_dialog_max"]
			#Caso houver outras combinações de _dialog_min e dialog_max disponiveis, retira a frase atual da pilha.
			if(_array_dialogue.size() > 1):
				_array_dialogue.pop_front()
			

		
			ChangeScene.scene_name = _cena_nome
			_new_dialog.mudaCena = _muda_cena
			_hud.add_child(_new_dialog)
			
			get_tree().paused = true
			dialogo_iniciado = true
	
			interacao.haInteracao = false
	

			
func _process(_delta: float) -> void:
	if(dialogo_iniciado):
		if(muda_pos):
			npc.markers = markers.duplicate()
			markers.clear()
		if(muda_falante):
			visible = false
			
			colisao.disabled = true
			falantes[id_falante].visible = true
			falantes[id_falante].colisao.disabled = false
		dialogo_iniciado = false
		#Desliga a interação por 0.2, com intuito de que, caso o usuário sem querer aperte o 
		#botão de interagir após o fim da interação, ou aperte de forma muito rápida
		#não irá reiniciar a interação de forma acidental.
		#Após dois segundos, liga novamente a interação.
		#await get_tree().create_timer(0.2).timeout
		interacao.haInteracao = true
		GameState.mudar_idle()
		
		if(fim):
			fim = false
			ChangeScene.scene_name = 'res://cenas/creditos/creditos.tscn'
			ChangeScene.change_scene() 
			
func _on_interacoes_area_entered(area: Area3D) -> void:
		if(area.get_parent().name == "Componente_Interacao"):
			if(!_hud.has_node('Dicas_ui') and (GameState.get_game_state() != 3 and GameState.get_game_state() != 4)):
				_new_dica = DICA.instantiate()
				_new_dica.dialogo = 'Aperte z para interagir!'
				_hud.add_child(_new_dica)


func _on_interacoes_area_exited(area: Area3D) -> void:
		if(area.get_parent().name == "Componente_Interacao"):	
			var dica = _hud.get_node_or_null("Dicas_ui")
			if dica:
				_hud.remove_child(dica)
				dica.queue_free()
				
func _muda_falante(id : int) -> void:
	muda_falante = true
	id_falante = id
