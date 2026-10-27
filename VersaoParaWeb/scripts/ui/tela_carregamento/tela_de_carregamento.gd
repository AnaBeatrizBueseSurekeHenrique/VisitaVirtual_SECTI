extends Control

class_name LoadingScreen

##Barra de progresso, utilizada para mostrar ao usuário a porcentagem de carregamento.
@onready var progress_bar = $PanelContainer2/PanelContainer2/PanelContainer/CenterContainer/VBoxContainer/ProgressBar
##Porcentagem, em números, de carregamento.
@onready var porcentagem = $PanelContainer2/PanelContainer2/PanelContainer/CenterContainer/VBoxContainer/HBoxContainer/Porcentagem
##Recebe em sua primeira posição um valor float, entre 0.0 e 1.0, que representa a porcentagem de carregamento.
var progress_array: Array = []

##Caminho da cena a ser carregada.
var scene_path : String
var number_jogador: int
##Função utilizada para carregar cenas.

func carregar_cena(scene_name: String):
	# ResourceLoader requisita carregamento da cena, utilizando threads.
	var error = ResourceLoader.load_threaded_request(scene_name)
	scene_path = scene_name
	if(error != OK):
		print('Erro!!')
		print(error)

func _process(_delta: float) -> void:
	##Variável status recebe o status do carregamento, indicando se ainda está em carregamento, se completou ou se falhou.
	var status = ResourceLoader.load_threaded_get_status(scene_path, progress_array)
	match status:
		##Caso ainda esteja sendo carregado, altera a barra de carregamento para indicar isto.
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			# Como o valor de progress_array vai de 0 a 1, e o valor da barra de progresso vai de 1 a 100, o valor a ser utilizado é multiplicado por 100.
			var progress = progress_array[0] * 100
			porcentagem.text = str(progress).pad_zeros(2).pad_decimals(0) + "%"
			# Altera o valor da barra de progresso.
			progress_bar.value = progress
			
		# Caso carregamento tenha terminado, troca de cena.
		ResourceLoader.THREAD_LOAD_LOADED:
			progress_bar.value = 100.0
			porcentagem.text = "100%"
			# Para a checagem de status
			
			set_process(false) # Stop checking the status
			
			# Recebe a cena carregada.
			var new_scene = ResourceLoader.load_threaded_get(scene_path)
			
			# Troca a cena atual para a carregada.
			await get_tree().process_frame 
			await Transition._entrar_cena()
			Transition.number_jogador = number_jogador
			await get_tree().process_frame
			get_tree().change_scene_to_packed(new_scene)
			await  Transition._sair_cena()
		# Caso haja falha
		# TODO: Criar cena para anuncio de erro.
		ResourceLoader.THREAD_LOAD_FAILED:
			print("Loading failed!")
			set_process(false)
		# Caso o caminho seja inválido
		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
			print("The requested resource path is invalid.")
			set_process(false)
