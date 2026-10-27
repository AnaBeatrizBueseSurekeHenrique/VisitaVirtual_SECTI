extends Node

enum State { ##Armazena o estado atual do jogador.
	PARADO, ##Jogador está parado, não se movimentando ou interagindo.
	ANDANDO, ## Jogador está caminhando, tendo contato com o chão.
	PULANDO, ## Jogador está pulando, ou seja, não tem contato com o chão
	SENTADO, ## Jogador interagiu com objeto sentável, e agora está sentando, não pode se movimentar até sair do objeto.
	CONVERSANDO, ## Jogador está em cena de dialogo.
	}
	
var game_state : State = State.PARADO 

##Retorna qual o estado de jogo atual:
## [br]
## [b]0[/b]: O estado de jogo atual é [b]State.PARADO[/b] [br]
## [b]1[/b]: O estado de jogo atual é [b]State.ANDANDO[/b] [br]
## [b]2[/b]: O estado de jogo atual é [b]State.PULANDO[/b] [br]
## [b]3[/b]: O estado de jogo atual é [b]State.SENTADO[/b] [br]
## [b]4[/b]: O estado de jogo atual é [b]State.CONVERSANDO[/b]
func get_game_state() -> int:
	match game_state:
		State.PARADO:
			return 0
		State.ANDANDO:
			return 1
		State.PULANDO:
			return 2
		State.SENTADO:
			return 3
		State.CONVERSANDO:
			return 4
	return -1

##Muda estado atual para PARADO, caso o jogador não estiver SENTADO.
func mudar_idle():
	if(game_state != State.SENTADO):
		game_state = State.PARADO
##Muda estado atual para ANDANDO, caso o jogador não estiver SENTADO.
func mudar_walking():
	if(game_state != State.SENTADO):
		game_state = State.ANDANDO
##Muda o estado atual para PULANDO, caso o jogador não estiver SENTADO.
func mudar_jumping():
	if(game_state != State.SENTADO):
		game_state = State.PULANDO
##Muda o estado atual para SENTADO, caso o jogador não estiver SENTADO. [br]
##Caso o jogador já estiver SENTADO, muda o estado atual para PARADO.
func mudar_sitting():
	if(game_state != State.SENTADO):
		game_state = State.SENTADO
	else:
		game_state = State.PARADO
##Muda o estado atual para CONVERSANDO.
func mudar_conversando():
	game_state = State.CONVERSANDO
