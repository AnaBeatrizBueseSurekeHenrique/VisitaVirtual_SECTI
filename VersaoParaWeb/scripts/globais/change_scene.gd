extends Node
##Variábel global resposável por alterar a cena atual, com uma transição para uma tela de carregamento.
const LOADING_SCREEN: PackedScene = preload("res://cenas/ui/loading_screen/loading_screen.tscn")
##Tela de carregamento, responsável por carregar a cena e realizar transições.
var loading_screen : LoadingScreen

##Nome da cena para qual será mudada.
var scene_name: String
##Em cenas onde há multiplas posições em que o jogador pode estar, armazena qual dessas posições o jogador estará.
var number_jogador: int = 1

func change_scene():
	loading_screen = LOADING_SCREEN.instantiate()
	loading_screen.number_jogador = number_jogador

	loading_screen.carregar_cena(scene_name)
	
	var current_scene = get_tree().current_scene
	
	await Transition._entrar_cena()
	get_tree().root.add_child(loading_screen)
	#Altera a cena atual para a tela de carregamento, e deleta a cena atual.
	#await Transition.transition_in(0.2)
	await get_tree().process_frame 
	get_tree().current_scene = loading_screen
	if current_scene:
		current_scene.queue_free()
