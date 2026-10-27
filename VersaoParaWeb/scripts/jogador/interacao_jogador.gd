extends Node3D

##Fila de prioridade das interações do jogador.
var interacao_atual := []

##Armazena se o jogador pode ou não interagir.
var pode_interagir := true

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("interagir") and pode_interagir:
		if interacao_atual:
			pode_interagir = false
			await interacao_atual[0].interagir.call()
			pode_interagir = true

		
func _ordena_por_mais_proximo(area1, area2):
	var area1_dist = global_position.distance_to(area1.global_position)
	var area2_dist = global_position.distance_to(area2.global_position)
	return area1_dist < area2_dist

##Ao jogador entrar em uma área que possui interações.
func _on_interacao_area_entered(area: Area3D) -> void:

	if(area.name == "Interacoes"):
		if(area not in interacao_atual and area.haInteracao):
			#Adiciona a fila de prioridade.
			interacao_atual.push_back(area)
			interacao_atual.sort_custom(_ordena_por_mais_proximo)


func _on_interacao_area_exited(area: Area3D) -> void:
	if(area.name == "Interacoes"):
		interacao_atual.erase(area)
		interacao_atual.sort_custom(_ordena_por_mais_proximo)
