extends CharacterBody3D

##Classe do jogador.
class_name Jogador
##Velocidade de caminhada do jogador.
const VELOCIDADE = 5.0
##Velocidade de corrida do jogador.
const VELOCIDADE_CORRER = 7.0
##Velocidade de pulo do jogador.
const VELOCIDADE_PULO = 4.5
const ROTACAO_CAMERA_MAX = 1.7
const ROTACAO_CAMERA_MIN = -1.5
@export var _hud : CanvasLayer
##Caso uma cena possuir diferentes posições em que um jogador pode estar ao entrar na cena 
##[i][Exemplo, jogador sai de um Cômodo B e entra em um Cômodo A por meio da Porta 1. Ao entrar novamente na Porta 1, será levado na frente da Porta 1 no Cômodo B.][/i]
@export var posicoes : Array[Marker3D] 
var posicao_atual : int

##Responsável por rotacionar e movimentar a camêra.
@onready var camera_controler = $Camera3D
var  sensibilidade_mouse : float = 0.4

var vel_atual : float = 0.0
##Menu de pausa.
var pausa : Pause
var _mouse_input : bool = false
var _mouse_rotation : Vector3
var _rotation_input : float
var _tilt_input : float
var _player_rotation : Vector3
var _camera_rotation : Vector3

##Lida com entrada de mouse, permitindo que o jogador rotacione a câmera.
func _unhandled_input(event):
	_mouse_input = event is InputEventMouseMotion
	if _mouse_input :
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		_rotation_input = -event.relative.x * sensibilidade_mouse
		_tilt_input = -event.relative.y * sensibilidade_mouse

func _ready() -> void:
	pausa = _hud.get_child(0)

	pausa.fov_number.text = str( ValoresJogador.fov)
	pausa.fov_slider.value =  ValoresJogador.fov
	pausa.mouse_slider.value = sensibilidade_mouse
	pausa.mouse_number.text = str(sensibilidade_mouse)
	camera_controler.pausa = pausa
	if(posicoes):
		position = posicoes[ChangeScene.number_jogador].position
	sensibilidade_mouse = ValoresJogador.sensibilidade_mouse
	camera_controler.fov = ValoresJogador.fov
	_mouse_rotation = self.rotation

func _input(event):
	#Ao usuário pressionar o botão de menu
	if(event.is_action_pressed("esc")):

		pausa.visible = true
		get_tree().paused = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
		while(pausa.is_visible_in_tree()):
			await get_tree().process_frame
		sensibilidade_mouse = pausa.mouse_slider.value
		ValoresJogador.sensibilidade_mouse = sensibilidade_mouse
		ValoresJogador.fov = pausa.fov_slider.value
##Responsável por atualizar a câmera, a movimentando com base na entrada do jogador.

func _update_camera(delta):

	_mouse_rotation.x += _tilt_input * delta
	_mouse_rotation.y += _rotation_input * delta

	_player_rotation = Vector3(0.0,_mouse_rotation.y,0.0)
	_camera_rotation = Vector3(_mouse_rotation.x, 0.0, 0.0)
	if _camera_rotation.x > ROTACAO_CAMERA_MIN and _camera_rotation.x < ROTACAO_CAMERA_MAX:
		camera_controler.transform.basis = Basis.from_euler(_camera_rotation)
	camera_controler.rotation.z = 0.0
	camera_controler.rotation.y = 0.0
	global_transform.basis = Basis.from_euler(_player_rotation)

	_rotation_input = 0.0
	_tilt_input = 0.0


func _physics_process(delta: float) -> void:
	if(position.y <= -100):
		position = posicoes[0].position
		position.y = 50
	if(Input.is_action_pressed('correr') and is_on_floor()):
		vel_atual = VELOCIDADE_CORRER
	else:
		if(Input.is_action_pressed("agachar") and is_on_floor()):
			vel_atual = VELOCIDADE/2
		else:
			vel_atual = VELOCIDADE
	#Verifica se o jogador não está sentando, se estiver, não pode se movimentar, caso contrário, segue normalmente.
	if(GameState.get_game_state() != 3):
		#Verifica se jogador está pulando
		if not is_on_floor():
			velocity += get_gravity() * delta
		
		if Input.is_action_just_pressed("pulo") and is_on_floor():
			velocity.y = VELOCIDADE_PULO
			
		var input_dir := Input.get_vector("esquerda", "direita", "cima", "baixo")
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		
		if direction:
			velocity.x = direction.x * vel_atual
			velocity.z = direction.z * vel_atual
			if(is_on_floor()):
				GameState.mudar_walking()
		else:
			velocity.x = move_toward(velocity.x, 0, vel_atual)
			velocity.z = move_toward(velocity.z, 0, vel_atual)
			GameState.mudar_idle()
		if(not is_on_floor()):
			GameState.mudar_jumping()

		move_and_slide()
	_update_camera(delta)
