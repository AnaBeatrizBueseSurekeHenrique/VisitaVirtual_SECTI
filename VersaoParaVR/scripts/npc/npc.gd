extends CharacterBody3D
##Script responsável por lidar com a movimentação de um NPC, caso ele precise se movimentar.

## Velocidade de caminhada
const SPEED = 4
## Intervalo aceitavel entre a distancia atual e a distancia desejada.
const INTERVALO = 1
## Pontos para onde se deseja movimentar.
@export var markers: Array[Marker3D]
## Armazena o objeto de interação de dialogo.
@export var dialogo : StaticBody3D
var caminhando : bool = false
var jaCaminhou = false
var parouCaminhar = false
var rotationou = false
var alvo
## Checa se ambas rotações são as mesmas.
func checkIfSame(rot1: float, rot2: float, interv: float):
	if(rot1 > rot2 - interv and rot1 < rot2 +interv):
		return true
	else:
		return false
func _physics_process(delta: float) -> void:
	var place : Vector3 = Vector3.ZERO
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		velocity.y -= 1
	
	if(markers):
		if(not rotationou):
			alvo = wrapf(markers.back().rotation.y - dialogo.rotation.y, -PI, PI)			
			rotationou = true
		if(not jaCaminhou and (checkIfSame(abs(Quaternion.from_euler(dialogo.rotation).y), abs(Quaternion.from_euler(Vector3(0,alvo,0)).y), 0.1))):
			caminhando = true
		dialogo.rotation.y = rotate_toward(dialogo.rotation.y,alvo, 5 * delta)
		dialogo.interacao.process_mode = Node.PROCESS_MODE_DISABLED
		#Verifica se a posição atual está dentro de um intervalo: posicão.x ∈ (x-INTERVALO, x+INTERVALO) e posição.z ∈ (z-INTERVALO, z+INTERVALO)
		# Caso estiver, então assume que o NPC está na posição, e remove da lista de posições que ele deve percorrer.
		if(position.x > markers.back().position.x -INTERVALO and position.x < markers.back().position.x +INTERVALO and ((position.z > markers.back().position.z -INTERVALO and position.z < markers.back().position.z +INTERVALO))):
			markers.pop_back()
			rotationou = false
			if(len(markers) < 1):
				dialogo.lobo_anim.play("Idle")
				parouCaminhar = true
				dialogo.interacao.process_mode = Node.PROCESS_MODE_INHERIT
				dialogo.ligar_interact()
		else:
			if(checkIfSame(abs(Quaternion.from_euler(dialogo.rotation).y), abs(Quaternion.from_euler(Vector3(0,alvo,0)).y), 0.1)):
				place.x = 1 if position.x < markers.back().position.x else -1 if position.x > markers.back().position.x else 0 
				
				place.z = 1 if position.z < markers.back().position.z else -1 if position.z > markers.back().position.z else 0 
			else:
				caminhando = false
				jaCaminhou = false	
				dialogo.lobo_anim.play("Idle")
		
	var direction := (transform.basis * Vector3(place.x, 0, place.z)).normalized()

	if direction:
		if(caminhando):
			dialogo.lobo_anim.stop()
			dialogo.lobo_anim.play("Caminhar_002")
			jaCaminhou = true
			caminhando = false
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()
