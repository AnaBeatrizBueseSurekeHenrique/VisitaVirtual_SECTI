extends Node

var dialogo : Variant
var caminho_dialogo_atual: String = "vazio"
##Responsável por carregar o .json do dialogo.
func carregarDialogo(caminho: String):
	var json = JSON.new()
	var file = FileAccess.open(caminho, FileAccess.READ)
	var _json_object = json.parse(file.get_as_text())
	file.close()
	dialogo = json.get_data()
	caminho_dialogo_atual = caminho
