extends Area3D

##Armazena nome da interação. Útil para caso uma interação tiver maior prioridade que outra.
@export var interacao_nome: String = ""

##Armazena se há uma interação disponível ou não.
@export var haInteracao: bool = true

##Função abstrata, scripts que possuem esse componente devem adicionar um corpo a esta função..
var interagir: Callable = func():
	pass
